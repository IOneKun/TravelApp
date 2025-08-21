import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

typealias StationSchedule = Components.Schemas.ScheduleResponse

protocol StationScheduleProtocol {
    func getStationSchedule(station: String, date: String?) async throws -> StationSchedule
}

final class StationScheduleService: StationScheduleProtocol {
    
    private let client: Client
    private let apikey: String
    
    init(client: Client, apikey: String) {
        self.client = client
        self.apikey = apikey
    }
    
    func getStationSchedule(station: String, date: String? = nil) async throws -> StationSchedule {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let finalDate = date ?? dateFormatter.string(from: Date())
        
        let response = try await client.getStationSchedule(query: .init(
            apikey: apikey,
            station: station,
            date: finalDate
            ))
        return try response.ok.body.json 
    }
}
