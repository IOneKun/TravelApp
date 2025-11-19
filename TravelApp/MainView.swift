import SwiftUI
import OpenAPIRuntime
import OpenAPIURLSession

enum MainDestination: Hashable {
    case stationSelection(selectingFromStation: Bool)
    case routeResults(from: StationUI, to: StationUI)
}

struct MainView: View {
   
    @StateObject private var viewModel = MainViewModel()
    @StateObject private var routeViewModel: RouteSearchViewModel = {
        let client = Client(serverURL: try! Servers.Server1.url(), transport: URLSessionTransport())
        let apiKey = "eff82f8a-e9b9-482c-b208-7ae87cf036e1"
        
        let scheduleService = SchedualBetweenStationsService(
            client: client,
            apikey: apiKey
        )
        
        let carrierService = CarrierService(
            client: client,
            apikey: apiKey
        )
        
        return RouteSearchViewModel(
            betweenStationsService: scheduleService,
            carrierService: carrierService
        )
    }()
    
    @ObservedObject private var errorManager = ErrorManager.shared
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            TabView(selection: $viewModel.selectedTab) {
                
                ZStack {
                    Color("tabBarColor").ignoresSafeArea()
                    
                    VStack {
                        StoriesView().padding(.top, 16)
                        
                        Spacer().frame(height: 44)
                        
                        stationPickerSection
                        
                        if viewModel.canSearch {
                            Button {
                                path.append(
                                    MainDestination.routeResults(
                                        from: viewModel.fromStation!,
                                        to: viewModel.toStation!
                                    )
                                )
                            } label: {
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
                }
                .tabItem { Image(systemName: "arrow.up.message.fill") }
                .tag(0)
                
                SettingsView()
                    .background(Color("tabBarColor").ignoresSafeArea())
                    .tabItem { Image(systemName: "gearshape.fill") }
                    .tag(1)
            }
            .navigationDestination(for: MainDestination.self) { destination in
                switch destination {
                case .stationSelection(let selectingFromStation):
                    CitySelectionView { station in
                        viewModel.setStation(station, selectingFromStation: selectingFromStation)
                        path.removeLast()
                    }
                    
                case .routeResults(let from, let to):
                    RouteListView(
                        from: from,
                        to: to,
                        date: Date().toAPIDateString(),
                        path: $path,
                        viewModel: routeViewModel
                    )
                }
            }
        }
    }

    private var stationPickerSection: some View {
        VStack(spacing: 0) {
            Button {
                path.append(MainDestination.stationSelection(selectingFromStation: true))
            } label: {
                HStack {
                    Text(viewModel.fromStation?.name ?? "Откуда")
                        .foregroundColor(viewModel.fromStation == nil ? Color("Gray_Universal") : Color("BLACK"))
                        .lineLimit(1)
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
                    Text(viewModel.toStation?.name ?? "Куда")
                        .foregroundColor(viewModel.toStation == nil ? Color("Gray_Universal") : Color("BLACK"))
                        .lineLimit(1)
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
            Button(action: { viewModel.swapStations() }) {
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
    }
}

