import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

typealias AllStations = Components.Schemas.AllStationsResponse

protocol AllStationsServiceProtocol {
    func getAllStations() async throws -> AllStations
}

actor AllStationsService: AllStationsServiceProtocol {
    
    private let client: Client
    private let apikey: String
    
    init(client: Client, apikey: String) {
        self.client = client
        self.apikey = apikey
    }
    
    func getAllStations() async throws -> AllStations {
       let response = try await client.getAllStations(query: .init(apikey: apikey))

       let responseBody = try response.ok.body.html

       let limit = 50 * 1024 * 1024 
        
        let fullData = try await Data(collecting: responseBody, upTo: limit)

       let allStations = try JSONDecoder().decode(AllStations.self, from: fullData)

       return allStations
    }
}

extension AllStations {
    func toUIModels(for city: String) -> [StationUI] {
        var result: [StationUI] = []
        
        countries?.forEach { country in
            country.regions?.forEach { region in
                region.settlements?.forEach { settlement in
                    if settlement.title == city {
                        settlement.stations?.forEach { station in
                            if let id = station.codes?.yandex_code,
                               let name = station.title {
                                result.append(
                                    StationUI(
                                        id: id,
                                        name: name)
                                    )
                            }
                        }
                    }
                }
            }
        }
        return result
    }
}


