import SwiftUI

@MainActor
final class MainViewModel: ObservableObject {
    
    @Published var fromStation: StationUI?
    @Published var toStation: StationUI?
    @Published var selectedTab = 0
    
    func setStation(_ station: StationUI, selectingFromStation: Bool) {
        if selectingFromStation {
            fromStation = station
        } else {
            toStation = station
        }
    }
    
    func swapStations() {
        let temp = fromStation
        fromStation = toStation
        toStation = temp
    }
    
    var canSearch: Bool {
        fromStation != nil && toStation != nil
    }
}

