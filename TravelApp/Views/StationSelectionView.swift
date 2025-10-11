import SwiftUI
import OpenAPIRuntime
import OpenAPIURLSession

struct StationSelectionView: View {
    @Environment(\.dismiss) private var dismiss
    let city: String
    let onSelect: (StationUI) -> Void
    
    @State private var searchText = ""
    @State private var stations: [StationUI] = []
    @State private var isLoading = true
    
    private var filteredStations: [StationUI] {
        if searchText.isEmpty {
            return stations
        } else {
            return stations.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        ZStack {
            Color("tabBarColor")
                .ignoresSafeArea()
                .zIndex(0)
            VStack(spacing: 0) {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(Color("Gray_Universal"))
                        .padding(.leading, 8)
                    
                    TextField("Введите запрос", text: $searchText)
                        .foregroundColor(Color("Black_Universal"))
                        .autocorrectionDisabled(true)
                    
                    if !searchText.isEmpty {
                        Button(action: { searchText = "" }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(Color("Gray_Universal"))
                        }
                    }
                }
                .frame(height: 36)
                .background(Color("Light_Gray"))
                .cornerRadius(10)
                .padding(.horizontal)
                
                if isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if stations.isEmpty {
                    Text("Станции не найдены")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List {
                        ForEach(filteredStations) { station in
                            Button {
                                onSelect(station)
                            } label: {
                                HStack {
                                    Text(station.name)
                                        .foregroundColor(Color("Black_Universal"))
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(Color("Black_Universal"))
                                }
                                .frame(height: 60)
                                .contentShape(Rectangle())
                            }
                            .listRowBackground(Color("tabBarColor"))
                            .buttonStyle(PlainButtonStyle())
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
                    .padding(.top)
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("Выбор станции")
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(Color("Black_Universal"))
                    }
                }
            }
            .task {
                await loadStations()
            }
        }
    }
    
    
    
    // MARK: Load Stations
    private func loadStations() async {
        do {
            let client = Client(
                serverURL: try Servers.Server1.url(),
                transport: URLSessionTransport()
            )
            let service = AllStationsService(
                client: client,
                apikey: "eff82f8a-e9b9-482c-b208-7ae87cf036e1"
            )
            
            let response = try await service.getAllStations()
            self.stations = response.toUIModels(for: city)
            self.isLoading = false
        } catch {
            ErrorManager.shared.handle(error: error)
            self.isLoading = false
        }
    }
}

