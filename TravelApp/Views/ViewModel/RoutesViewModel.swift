import SwiftUI

@MainActor
final class RouteSearchViewModel: ObservableObject {
    
    @Published var routes: [RouteModel] = []
    @Published var filteredRoutes: [RouteModel] = []
    @Published var isLoading: Bool = false
    
    private let betweenStationsService: ScheduleBetweenStationsProtocol
    private let carrierService: CarrierServiceProtocol
    
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
        
        do {
            let response = try await betweenStationsService.getSchedualBetweenStations(
                from: from,
                to: to,
                date: date,
                transfers: true
            )
            
            var mappedRoutes: [RouteModel] = []
            
            for segment in response.segments ?? [] {
                guard
                    let fromTitle = segment.from?.title,
                    let toTitle = segment.to?.title,
                    let departure = segment.departure,
                    let arrival = segment.arrival
                else { continue }
                
                let carrierName = segment.thread?.carrier?.title ?? "Нет имени перевозчика"
                let carrierLogo = segment.thread?.carrier?.logo ?? ""
                let duration = segment.duration ?? 0
                let carrierCode = String(segment.thread?.carrier?.code ?? 0)
                let carrierSystem = segment.thread?.carrier?.codes?.iata ?? "yandex"

                
                let carrierInfo = try? await carrierService.getCarrierInfo(
                    code: carrierCode,
                    system: carrierSystem
                )
                
                let carrierPhone = carrierInfo?.carrier?.phone
                let carrierEmail = carrierInfo?.carrier?.email
                
                let route = RouteModel(
                    fromTitle: fromTitle,
                    toTitle: toTitle,
                    departure: departure,
                    arrival: arrival,
                    carrierName: carrierName,
                    carrierLogo: carrierLogo,
                    duration: duration,
                    transferCity: nil, carrierPhone: carrierPhone, carrierEmail: carrierEmail,
                    hasTransfer: false
                )
                mappedRoutes.append(route)
            }
            
            for interval in response.interval_segments ?? [] {
                guard
                    let fromTitle = interval.from?.title,
                    let toTitle = interval.to?.title,
                    let beginTime = interval.interval?.begin_time,
                    let endTime = interval.interval?.end_time
                else { continue }
                
                let carrierName = interval.thread?.carrier?.title ?? "Нет имени перевозчика"
                let carrierLogo = interval.thread?.carrier?.logo ?? ""
                let duration = interval.duration ?? 0
                
                let route = RouteModel(
                    fromTitle: fromTitle,
                    toTitle: toTitle,
                    departure: beginTime,
                    arrival: endTime,
                    carrierName: carrierName,
                    carrierLogo: carrierLogo,
                    duration: duration,
                    transferCity: nil,
                    carrierPhone: nil,
                    carrierEmail: nil,
                    hasTransfer: interval.has_transfers ?? false
                )
                mappedRoutes.append(route)
            }
            
            routes = mappedRoutes
            filteredRoutes = mappedRoutes
            isLoading = false
            
        } catch {
            ErrorManager.shared.handle(error: error)
            isLoading = false
        }
    }
    
    
    func applyFilters(times: Set<String>, allowTransfers: Bool?) {
        print("APPLY FILTERS", times)
        var filtered = routes
        
        if !times.isEmpty {
            filtered = filtered.filter { route in
                times.contains(route.timeCategory)
            }
        }
        
        if let allow = allowTransfers {
            filtered = filtered.filter { route in
                allow ? route.hasTransfer : !route.hasTransfer
            }
        }
        print("FILTERED ROUTES", filtered.map { $0.fromTitle + "→" + $0.toTitle })
        filteredRoutes = filtered
    }
}

