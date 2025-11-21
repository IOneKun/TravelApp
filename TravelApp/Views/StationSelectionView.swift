import SwiftUI
import OpenAPIURLSession

struct StationSelectionView: View {
    @Environment(\.dismiss) private var dismiss
    let city: String
    let onSelect: (StationUI) -> Void
    
    @StateObject private var viewModel: StationSelectionViewModel
    @State private var searchText = ""
    
    init(city: String, onSelect: @escaping (StationUI) -> Void) {
        self.city = city
        self.onSelect = onSelect
        let client = Client(
            serverURL: try! Servers.Server1.url(),
            transport: URLSessionTransport()
        )
        let service = AllStationsService(client: client, apikey: "eff82f8a-e9b9-482c-b208-7ae87cf036e1")
        _viewModel = StateObject(wrappedValue: StationSelectionViewModel(service: service))
    }
    
    var body: some View {
        ZStack {
            Color("tabBarColor").ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Поиск
                HStack {
                    Image(systemName: "magnifyingglass").foregroundColor(Color("Gray_Universal")).padding(.leading, 8)
                    TextField("Введите запрос", text: $searchText)
                        .foregroundColor(Color("Black_Universal"))
                        .autocorrectionDisabled(true)
                        .onChange(of: searchText) { newValue in
                            viewModel.filterStations(searchText: newValue)
                        }
                    if !searchText.isEmpty {
                        Button { searchText = "" } label: {
                            Image(systemName: "xmark.circle.fill").foregroundColor(Color("Gray_Universal"))
                        }
                    }
                }
                .frame(height: 36)
                .background(Color("Light_Gray"))
                .cornerRadius(10)
                .padding(.horizontal)
                
                if viewModel.isLoading {
                    ProgressView().frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if viewModel.filteredStations.isEmpty {
                    Text("Станции не найдены").frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List(viewModel.filteredStations) { station in
                        Button {
                            onSelect(station)
                        } label: {
                            HStack {
                                Text(station.name).foregroundColor(Color("Black_Universal"))
                                Spacer()
                                Image(systemName: "chevron.right").foregroundColor(Color("Black_Universal"))
                            }
                            .frame(height: 60)
                            .contentShape(Rectangle())
                        }
                        .listRowBackground(Color("tabBarColor"))
                        .buttonStyle(PlainButtonStyle())
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
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
                    Button { dismiss() } label: {
                        Image(systemName: "chevron.left").foregroundColor(Color("Black_Universal"))
                    }
                }
            }
            .task {
                await viewModel.loadStations(for: city)
                viewModel.filterStations(searchText: searchText)
            }
        }
    }
}

