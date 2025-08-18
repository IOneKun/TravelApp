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
            testCarrierService()
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

func testCarrierService() {
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
            print("Fetching carrier..")
            let carrierResponse = try await service.getCarrierInfo(
                code: "SU",
                system: "iata"
            )
            print("Successfully fetched carriers: \(carrierResponse)")
            if let carriers = carrierResponse.carriers, !carriers.isEmpty {
                for carrier in carriers {
                    print("Carrier name: \(carrier.title ?? "")")
                    print("Carrier code: \(carrier.code ?? 0)")
                    print("Carrier url: \(carrier.url ?? "–")")
                }
            } else {
                print("No carriers found for this code")
            }
        } catch {
            print("Error fetching carriers: \(error)")
        }
    }
}

func testRouteStations() {
    Task {
        do {
            let client = Client(
                serverURL: try Servers.Server1.url(),
                transport: URLSessionTransport()
            )
            let service = RouteStationsService(
                client: client,
                apikey: "eff82f8a-e9b9-482c-b208-7ae87cf036e1"
            )
            print("Fetching stations..")
            let stations = try await service.getRouteStations(
                uid: "s9600213"
            )
            print("Successfully fetched stations: \(stations)")
        } catch {
            print("Error fetching stations: \(error)")
        }
    }
}

func testAllStations() {
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

func testNearestCity() {
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
            let cities = try await service.getNearestCity(lat: 222, lng: 111)
            print("Successfully fetched cities: \(cities)")
        } catch {
            print("Error fetching cities: \(error)")
        }
    }
}

func testCopyright() {
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

func testStationSchedule() {
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
            let stationSchedule = try await service.getStationSchedule(station: "Msc")
            print("Successfully fetched station schedule: \(stationSchedule)")
        } catch {
            print("Error fetching stationsSchedule: \(error)")
        }
    }
}

func testScheduleBetweenStations() {
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
            let schedule = try await service.getSchedualBetweenStations(from: "Msc", to: "Spb")
            print("Successfully fetched station schedule: \(schedule)")
        } catch {
            print("Error fetching schedule: \(error)")
        }
    }
}

#Preview {
    ContentView()
}

