import SwiftUI

@MainActor
final class RouteSearchViewModel: ObservableObject {
    @Published var routes: [RouteModel] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
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
        isLoading = true
        errorMessage = nil
        routes = []
        
        do {
        
            let response = try await betweenStationsService.getSchedualBetweenStations(
                from: from,
                to: to,
                date: date
            )
            
            var mappedRoutes: [RouteModel] = []
            
            for segment in response.segments ?? [] {
                
                let carrierCode = segment.thread?.carrier?.codes?.iata
                ?? segment.thread?.carrier?.codes?.sirena
                ?? segment.thread?.carrier?.codes?.icao
                
                var carrierName = segment.thread?.carrier?.title ?? "Неизвестно"
                var carrierLogo = ""
                
                if let code = carrierCode {
                    do {
                        let carrierInfo = try await carrierService.getCarrierInfo(
                            code: code,
                            system: "iata"
                        )
                        if let carrier = carrierInfo.carrier {
                            carrierName = carrier.title ?? carrierName
                            carrierLogo = carrier.logo ?? ""
                        }
                    } catch {
                        print("Не удалось загрузить carrier: \(error.localizedDescription)")
                    }
                }
                
                guard let departure = segment.departure,
                      let arrival = segment.arrival else {
                    continue
                }
                
                let model = RouteModel(
                    carrierName: carrierName,
                    carrierAvatarURL: carrierLogo,
                    date: Calendar.current.startOfDay(for: departure),
                    transferCity: nil,
                    departure: departure,
                    arrival: arrival,
                    duration: arrival.timeIntervalSince(departure),
                    hasTransfers: false
                )
                mappedRoutes.append(model)
            }
            routes = mappedRoutes
        } catch {
            errorMessage = "Ошибка: \(error.localizedDescription)"
        }
        isLoading = false
    }
}

