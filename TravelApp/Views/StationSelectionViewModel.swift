import SwiftUI

@MainActor
final class StationSelectionViewModel: ObservableObject {
    @Published var stations: [StationUI] = []
    @Published var isLoading = false
    
    private let service: AllStationsService
    
    init(service: AllStationsService) {
        self.service = service
    }
    
    var filteredStations: [StationUI] = []
    
    func loadStations(for city: String) async {
        isLoading = true
        do {
            let response = try await service.getAllStations()
            let uiStations = response.toUIModels(for: city)
            self.stations = uiStations
        } catch {
            ErrorManager.shared.handle(error: error)
        }
        isLoading = false
    }
    
    func filterStations(searchText: String) {
        if searchText.isEmpty {
            filteredStations = stations
        } else {
            filteredStations = stations.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
}
