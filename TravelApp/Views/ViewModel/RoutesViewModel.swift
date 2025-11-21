import SwiftUI

@MainActor
final class RouteSearchViewModel: ObservableObject {
    @Published var routes: [RouteModel] = []
    @Published var filteredRoutes: [RouteModel] = []
    @Published var isLoading: Bool = false
    
    private let betweenStationsService: ScheduleBetweenStationsProtocol
    private let carrierService: CarrierServiceProtocol
    
    private let isoDateFormatter: ISO8601DateFormatter = {
        let d = ISO8601DateFormatter()
        d.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return d
    }()
    
    init(
        betweenStationsService: ScheduleBetweenStationsProtocol,
        carrierService: CarrierServiceProtocol
    ) {
        self.betweenStationsService = betweenStationsService
        self.carrierService = carrierService
    }
    
    func searchRoutes(from: String, to: String, date: String) async {
        if isLoading { return }
        isLoading = true
        routes = []
        filteredRoutes = []
        
        do {
            // 1) Загрузка данных
            let response = try await betweenStationsService.getSchedualBetweenStations(
                from: from,
                to: to,
                date: date,
                transfers: true
            )
            
            struct SegmentData: Sendable {
                let fromTitle: String
                let toTitle: String
                let departure: Date
                let arrival: Date
                let carrierCode: String
                let carrierSystem: String
                let carrierName: String
                let carrierLogo: String?
                let duration: Int
            }
            
            struct IntervalData: Sendable {
                let fromTitle: String
                let toTitle: String
                let beginTime: Date
                let endTime: Date
                let carrierName: String
                let carrierLogo: String?
                let duration: Int
                let hasTransfers: Bool
            }
            
            var segmentDatas: [SegmentData] = []
            var intervalDatas: [IntervalData] = []
            
            for segment in response.segments ?? [] {
                guard
                    let fromTitle = segment.from?.title,
                    let toTitle = segment.to?.title,
                    let departure = segment.departure,
                    let arrival = segment.arrival
                else { continue }
                
                let carrierName = segment.thread?.carrier?.title ?? "Нет имени перевозчика"
                let carrierLogo = segment.thread?.carrier?.logo
                let carrierCode = String(segment.thread?.carrier?.code ?? 0)
                let carrierSystem = segment.thread?.carrier?.codes?.iata ?? "yandex"
                let duration = segment.duration ?? 0
                
                segmentDatas.append(
                    SegmentData(
                        fromTitle: fromTitle,
                        toTitle: toTitle,
                        departure: departure,
                        arrival: arrival,
                        carrierCode: carrierCode,
                        carrierSystem: carrierSystem,
                        carrierName: carrierName,
                        carrierLogo: carrierLogo,
                        duration: duration
                    )
                )
            }
            
            for interval in response.interval_segments ?? [] {
                guard
                    let fromTitle = interval.from?.title,
                    let toTitle = interval.to?.title,
                    let beginTime = interval.interval?.begin_time,
                    let endTime = interval.interval?.end_time
                else { continue }
                
                let carrierName = interval.thread?.carrier?.title ?? "Нет имени перевозчика"
                let carrierLogo = interval.thread?.carrier?.logo
                let duration = interval.duration ?? 0
                let hasTransfers = interval.has_transfers ?? false
                
                intervalDatas.append(
                    IntervalData(
                        fromTitle: fromTitle,
                        toTitle: toTitle,
                        beginTime: beginTime,
                        endTime: endTime,
                        carrierName: carrierName,
                        carrierLogo: carrierLogo,
                        duration: duration,
                        hasTransfers: hasTransfers
                    )
                )
            }
            
            var mappedRoutes: [RouteModel] = []
            
            await withTaskGroup(of: RouteModel?.self) { group in
                
                for s in segmentDatas {
                    group.addTask { [carrierService, isoDateFormatter] in
                        let departureDate = s.departure
                        let arrivalDate = s.arrival
                        var phone: String? = nil
                        var email: String? = nil
                        
                        
                        do {
                            let carrierInfo = try await carrierService.getCarrierInfo(
                                code: s.carrierCode,
                                system: s.carrierSystem
                            )
                            phone = carrierInfo.carrier?.phone
                            email = carrierInfo.carrier?.email
                        } catch {
                            
                        }
                        
                        return RouteModel(
                            fromTitle: s.fromTitle,
                            toTitle: s.toTitle,
                            departure: departureDate,
                            arrival: arrivalDate,
                            carrierName: s.carrierName,
                            carrierLogo: s.carrierLogo ?? "",
                            duration: s.duration,
                            transferCity: nil,
                            carrierPhone: phone,
                            carrierEmail: email,
                            hasTransfer: false
                        )
                    }
                }
                
                for i in intervalDatas {
                    group.addTask { [isoDateFormatter] in
                        let departureDate = i.beginTime
                        let arrivalDate = i.endTime
                        
                        return RouteModel(
                            fromTitle: i.fromTitle,
                            toTitle: i.toTitle,
                            departure: departureDate,
                            arrival: arrivalDate,
                            carrierName: i.carrierName,
                            carrierLogo: i.carrierLogo ?? "",
                            duration: i.duration,
                            transferCity: nil,
                            carrierPhone: nil,
                            carrierEmail: nil,
                            hasTransfer: i.hasTransfers
                        )
                    }
                }
                
                for await result in group {
                    if let r = result {
                        mappedRoutes.append(r)
                    }
                }
            }
            
            routes = mappedRoutes
            filteredRoutes = mappedRoutes
            isLoading = false
            
        } catch {
            ErrorManager.shared.handle(error: error)
            isLoading = false
        }
    }
}

extension RouteSearchViewModel {
    func applyFilters(times: Set<String>, allowTransfers: Bool?) {
        filteredRoutes = routes.filter { route in
            var matchesTime = true
            if !times.isEmpty {
                let hour = Calendar.current.component(.hour, from: route.departure)
                matchesTime = times.contains { time in
                    switch time {
                    case "Утро 6:00 - 12:00": return hour >= 6 && hour < 12
                    case "День 12:00 - 18:00": return hour >= 12 && hour < 18
                    case "Вечер 18:00 - 00:00": return hour >= 18 && hour < 24
                    case "Ночь 00:00 - 06:00": return hour >= 0 && hour < 6
                    default: return false
                    }
                }
            }
            
            var matchesTransfer = true
            if let allowTransfers = allowTransfers {
                matchesTransfer = route.hasTransfer == allowTransfers
            }
            
            return matchesTime && matchesTransfer
        }
    }
}
