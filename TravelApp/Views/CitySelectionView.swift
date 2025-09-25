import SwiftUI
import OpenAPIRuntime
import OpenAPIURLSession

struct CitySelectionView: View {
    @Environment(\.dismiss) private var dismiss
    let onSelect: (StationUI) -> Void
    
    @State private var searchText = ""
    @State private var selectedCity: String? = nil
    @State private var goToStations = false
    
    private let cities = [
        "Москва",
        "Санкт-Петербург",
        "Сочи",
        "Горный Воздух",
        "Краснодар",
        "Казань",
        "Омск",
        "Анапа",
        "Новороссийск",
        "Владивосток"
    ]
    
    private var filteredCities: [String] {
        if searchText.isEmpty {
            return cities
        } else {
            return cities.filter { $0.localizedCaseInsensitiveContains(searchText)}
        }
    }
    
    var body: some View {
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
            
            if filteredCities.isEmpty && !searchText.isEmpty {
                VStack {
                    Spacer()
                    Text("Город не найден")
                        .foregroundColor(Color("Black_Universal"))
                        .font(.system(size: 24, weight: .bold))
                        .padding(.vertical, 20)
                    Spacer()
                }
            } else {
                List {
                    ForEach(filteredCities, id: \.self) { city in
                        Button {
                            selectedCity = city
                            goToStations = true
                        } label: {
                            HStack {
                                Text(city)
                                    .foregroundColor(.black)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.black)
                            }
                            .frame(height: 60)
                            .contentShape(Rectangle())
                        }
                        .listRowBackground(Color.white)
                        .buttonStyle(PlainButtonStyle())
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                    }
                }
            }
        }
        .listStyle(PlainListStyle())
        .background(Color.white)
        .navigationTitle("Выбор города")
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
        .navigationDestination(isPresented: $goToStations) {
            if let city = selectedCity {
                StationSelectionView(city: city) { selectedStation in
                    onSelect(selectedStation)
                    dismiss()
                }
            }
        }
    }
}

