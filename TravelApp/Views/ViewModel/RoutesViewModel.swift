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
                date: date,
                transfers: true
            )
            
            do {
                    let encoder = JSONEncoder()
                    encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
                    let data = try encoder.encode(response)
                    if let jsonString = String(data: data, encoding: .utf8) {
                        print("=== FULL RESPONSE JSON ===")
                        print(jsonString)
                    }
                } catch {
                    print("Ошибка кодирования ответа в JSON: \(error)")
                }
            
            var mappedRoutes: [RouteModel] = []
            
            for segment in response.segments ?? [] {
                guard
                    let fromTitle = segment.from?.title,
                    let toTitle = segment.to?.title,
                    let departure = segment.departure,
                    let arrival = segment.arrival
                else { continue }
                
                let carrierName = segment.thread?.carrier?.title ?? "Нет имени перевозчика"
                let carrierLogo = segment.thread?.carrier?.logo ?? "Нет лого перевозчика"
                let duration = segment.duration ?? 0
                
                let route = RouteModel(
                    fromTitle: fromTitle,
                    toTitle: toTitle,
                    departure: departure,
                    arrival: arrival,
                    carrierName: carrierName,
                    carrierLogo: carrierLogo,
                    duration: duration,
                    transferCity: nil
                )
                
                mappedRoutes.append(route)
            }
            
            routes = mappedRoutes
        } catch {
            errorMessage = "Ошибка: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
}
