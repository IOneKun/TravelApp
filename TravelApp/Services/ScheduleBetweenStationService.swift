import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

typealias ScheduleBetweenStations = Components.Schemas.Segments

protocol ScheduleBetweenStationsProtocol {
    func getSchedualBetweenStations(from: String, to: String, date: String?, transfers: Bool) async throws -> ScheduleBetweenStations
}

actor SchedualBetweenStationsService: ScheduleBetweenStationsProtocol {
    
    private let client: Client
    private let apikey: String
    
    init(client: Client, apikey: String) {
        self.client = client
        self.apikey = apikey
    }
    
    func getSchedualBetweenStations(from: String, to: String, date: String? = nil, transfers: Bool) async throws -> ScheduleBetweenStations {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let finalDate = date ?? dateFormatter.string(from: Date())
        
        let response = try await client.getSchedualBetweenStations(query: .init(
            apikey: apikey,
            from: from,
            to: to,
            date: finalDate,
            transfers: transfers
        ))
        return try response.ok.body.json
    }
}
