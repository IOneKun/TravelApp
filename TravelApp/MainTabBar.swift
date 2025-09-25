import SwiftUI
import OpenAPIRuntime
import OpenAPIURLSession

enum MainDestination: Hashable {
    case stationSelection(selectingFromStation: Bool)
    case routeResults(from: StationUI, to: StationUI)
}

private let apiKey = "eff82f8a-e9b9-482c-b208-7ae87cf036e1"

struct MainView: View {
    @State private var fromStation: StationUI?
    @State private var toStation: StationUI?
    @State private var path = NavigationPath()
    @State private var isLoading = false
    
    var body: some View {
        NavigationStack(path: $path) {
            TabView {
                VStack {
                    Spacer()
                    VStack(spacing: 0) {
                        Button {
                            path.append(MainDestination.stationSelection(selectingFromStation: true))
                        } label: {
                            HStack {
                                Text(fromStation?.name ?? "Откуда")
                                    .foregroundColor(fromStation == nil ? Color("Gray_Universal") : Color("Black_Universal"))
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                                Spacer()
                            }
                            .padding()
                            .background(Color("White_Universal"))
                            .cornerRadius(20)
                            .frame(width: 259)
                        }
                        Button {
                            path.append(MainDestination.stationSelection(selectingFromStation: false))
                        } label: {
                            HStack {
                                Text(toStation?.name ?? "Куда")
                                    .foregroundColor(toStation == nil ? Color("Gray_Universal") : Color("Black_Universal"))
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                                Spacer()
                            }
                            .padding()
                            .background(Color("White_Universal"))
                            .cornerRadius(20)
                            .frame(width: 259)
                        }
                    }
                    .background(Color.white)
                    .cornerRadius(20)
                    .padding(.trailing, 48)
                    .frame(width: 343, height: 128)
                    .background(Color("Blue_Universal"))
                    .cornerRadius(20)
                    .overlay(
                        Button(action: swapCities) {
                            Image(systemName: "arrow.2.squarepath")
                                .font(.system(size: 24))
                                .foregroundColor(Color("Blue_Universal"))
                                .padding(8)
                                .background(Color("White_Universal"))
                                .clipShape(Circle())
                                .shadow(radius: 2)
                        }
                            .offset(x: -8),
                        alignment: .trailing
                    )
                    
                   
                    if let from = fromStation, let to = toStation {
                        Button(action: {
                            path.append(MainDestination.routeResults(from: from, to: to))
                        }) {
                            Text("Найти")
                                .font(.system(size: 17, weight: .bold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color("Blue_Universal"))
                                .cornerRadius(16)
                                .frame(width: 150, height: 60)
                        }
                    }
                    Spacer()
                }
                .tabItem {
                    Image(systemName: "arrow.up.message.fill")
                }
                SettingsView()
                    .tabItem {
                        Image(systemName: "gearshape.fill")
                    }
            }
            .tint(Color("Black_Universal"))
            .navigationDestination(for: MainDestination.self) { destination in
                switch destination {
                case .stationSelection(let selectingFromStation):
                    CitySelectionView { selectedStation in
                        if selectingFromStation {
                            fromStation = selectedStation
                        } else {
                            toStation = selectedStation
                        }
                        path.removeLast(path.count)
                    }
                case .routeResults(let from, let to):
                    let client = Client(serverURL: try! Servers.Server1.url(), transport: URLSessionTransport())
                    let scheduleService = SchedualBetweenStationsService(client: client, apikey: apiKey)
                    let carrierService = CarrierService(client: client, apikey: apiKey)
                    RouteListView(
                        from: from,
                        to: to,
                        
                        betweenStationsService: scheduleService,
                        carrierService: carrierService
                    )
                }
            }
        }
    }
    
    private func swapCities() {
        let temp = fromStation
        fromStation = toStation
        toStation = temp
    }
    
    private func searchAction() {
        print("searching")
    }
}
    struct SettingsView: View {
        var body: some View {
            NavigationStack {
                Text("Здесь будут настройки")
                    .navigationTitle("Настройки")
            }
        }
    }
    
    #Preview {
        MainView()
}
