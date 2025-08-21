import OpenAPIURLSession
import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .onAppear {
            testRouteStations()
        }
    }
}

func testNearestStations() {  //Working well
    Task {
        do {
            let client = Client(
                serverURL: try Servers.Server1.url(),
                transport: URLSessionTransport()
            )
            let service = NearestStationService(
                client: client,
                apikey: "eff82f8a-e9b9-482c-b208-7ae87cf036e1"
            )
            print("Fetching stations..")
            let stations = try await service.getNearestStations(
                lat: 0.0001,
                lng: 0.0034,
                distance: 10
            )
            print("Successfully fetched stations: \(stations)")
        } catch {
            print("Error fetching stations: \(error)")
        }
    }
}

func testCarrierService() { //Working well
    Task {
        do {
            let client = Client(
                serverURL: try Servers.Server1.url(),
                transport: URLSessionTransport()
            )
            
            let service = CarrierService(
                client: client,
                apikey: "eff82f8a-e9b9-482c-b208-7ae87cf036e1"
            )
            
            let result = try await service.getCarrierInfo(code: "LH", system: "iata")
            print("\(result)")
        } catch {
            print("Error fetching carriers: \(error)")
        }
    }
}

func testRouteStations() {  //Working Well
    Task {
        do {
            let client = Client(
                serverURL: try Servers.Server1.url(),
                transport: URLSessionTransport()
            )
            
            let scheduleService = StationScheduleService(
                client: client,
                apikey: "eff82f8a-e9b9-482c-b208-7ae87cf036e1"
            )
            
            let station = "s9600213"
            
            print("Fetching schedule..")
            let scheduleResponse = try await scheduleService.getStationSchedule(
                station: station
            )
            
            guard let firstSegment = scheduleResponse.schedule?.first,
                  let threadUID = firstSegment.thread?.uid else {
                print("No segments found")
                return
            }
            
            print("Found thread UID: \(threadUID)")
            
            let routeStationsService = RouteStationsService(
                client: client,
                apikey: "eff82f8a-e9b9-482c-b208-7ae87cf036e1"
            )
            
            let stationsResponse = try await routeStationsService.getRouteStations(uid: threadUID)
            
            print("Successfully fetched stations: \(stationsResponse)")
            
        } catch {
            print("Error fetching route stations: \(error)")
        }
    }
}

func testAllStations() { //Working well
    Task {
        do {
            let client = Client(
                serverURL: try Servers.Server1.url(),
                transport: URLSessionTransport()
            )
            let service = AllStationsService(
                client: client,
                apikey: "eff82f8a-e9b9-482c-b208-7ae87cf036e1"
            )
            print("Fetching stations..")
            let stations = try await service.getAllStations()
            print("Successfully fetched stations: \(stations)")
        } catch {
            print("Error fetching stations: \(error)")
        }
    }
}

func testNearestCity() { //Working well
    Task {
        do {
            let client = Client(
                serverURL: try Servers.Server1.url(),
                transport: URLSessionTransport()
            )
            let service = NearestCityService(
                client: client,
                apikey: "eff82f8a-e9b9-482c-b208-7ae87cf036e1"
            )
            print("Fetching cities..")
            let cities = try await service.getNearestCity(lat:  55.7558, lng:  37.6176)
            print("Successfully fetched cities: \(cities)")
        } catch {
            print("Error fetching cities: \(error)")
        }
    }
}

func testCopyright() {  //Working well
    Task {
        do {
            let client = Client(
                serverURL: try Servers.Server1.url(),
                transport: URLSessionTransport()
            )
            let service = CopyrightService(
                client: client,
                apikey: "eff82f8a-e9b9-482c-b208-7ae87cf036e1"
            )
            print("Fetching copyrights..")
            let copyrights = try await service.getCopyright()
            print("Successfully fetched copyrights: \(copyrights)")
        } catch {
            print("Error fetching copyrights: \(error)")
        }
    }
}

func testStationSchedule() { //Working Well
    Task {
        do {
            let client = Client(
                serverURL: try Servers.Server1.url(),
                transport: URLSessionTransport()
            )
            let service = StationScheduleService(
                client: client,
                apikey: "eff82f8a-e9b9-482c-b208-7ae87cf036e1"
            )
            print("Fetching schedule..")
            let stationSchedule = try await service.getStationSchedule(station: "s9600213")
            print("Successfully fetched station schedule: \(stationSchedule)")
        } catch {
            print("Error fetching stationsSchedule: \(error)")
        }
    }
}

func testScheduleBetweenStations() { //Working Well
    Task {
        do {
            let client = Client(
                serverURL: try Servers.Server1.url(),
                transport: URLSessionTransport()
            )
            let service = SchedualBetweenStationsService(
                client: client,
                apikey: "eff82f8a-e9b9-482c-b208-7ae87cf036e1"
            )
            print("Fetching schedule..")
            let schedule = try await service.getSchedualBetweenStations(from: "c146", to: "c213")
            print("Successfully fetched station schedule: \(schedule)")
        } catch {
            print("Error fetching schedule: \(error)")
        }
    }
}

#Preview {
    ContentView()
}

