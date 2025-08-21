import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

typealias ScheduleBetweenStations = Components.Schemas.Segments

protocol ScheduleBetweenStationsProtocol {
    func getSchedualBetweenStations(from: String, to: String, date: String?) async throws -> ScheduleBetweenStations
}

final class SchedualBetweenStationsService: ScheduleBetweenStationsProtocol {
    
    private let client: Client
    private let apikey: String
    
    init(client: Client, apikey: String) {
        self.client = client
        self.apikey = apikey
    }
    
    func getSchedualBetweenStations(from: String, to: String, date: String? = nil) async throws -> ScheduleBetweenStations {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let finalDate = date ?? dateFormatter.string(from: Date())
        
        let response = try await client.getSchedualBetweenStations(query: .init(
            apikey: apikey,
            from: from,
            to: to,
            date: finalDate
        ))
        return try response.ok.body.json
    }
}
