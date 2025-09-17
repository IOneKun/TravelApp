import SwiftUI

enum MainDestination: Hashable {
    case citySelection(selectingFromCity: Bool)
    case stationSelection(city: String, selectingFromCity: Bool)
}

struct MainView: View {
    @State private var fromCity: String = ""
    @State private var toCity: String = ""
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            TabView {
                VStack {
                    Spacer()
                    VStack(spacing: 0) {
                        Button {
                            path.append(MainDestination.citySelection(selectingFromCity: true))
                        } label: {
                            HStack {
                                Text(fromCity.isEmpty ? "Откуда" : fromCity)
                                    .foregroundColor(fromCity.isEmpty ? .gray : .black)
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                                Spacer()
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(20)
                            .frame(width: 259)
                        }
                        Button {
                            path.append(MainDestination.citySelection(selectingFromCity: false))
                        } label: {
                            HStack {
                                Text(toCity.isEmpty ? "Куда" : toCity)
                                    .foregroundColor(toCity.isEmpty ? .gray : .black)
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                                Spacer()
                            }
                            .padding()
                            .background(Color.white)
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
                                .background(Color.white)
                                .clipShape(Circle())
                                .shadow(radius: 2)
                        }
                            .offset(x: -8),
                        alignment: .trailing
                    )
                    
                    Button(action: searchAction) {
                        Text("Найти")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color("Blue_Universal"))
                            .cornerRadius(16)
                            .frame(width: 150, height: 60)
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
            .tint(.black)
            .navigationDestination(for: MainDestination.self) { destination in
                switch destination {
                case .citySelection(let selectingFromCity):
                    CitySelectionView { selectedCity in
                        if selectingFromCity {
                            fromCity = selectedCity
                        } else {
                            toCity = selectedCity
                        }
                        path.removeLast(path.count)
                    }
                case .stationSelection(let city, let selectingFromCity):
                    StationSelectionView(city: city) { station in
                        if selectingFromCity {
                            fromCity = station
                        } else {
                            toCity = station 
                        }
                        path.removeLast(path.count)
                    }
                }
            }
        }
    }
    
    private func swapCities() {
        let temp = fromCity
        fromCity = toCity
        toCity = temp
    }
    
    private func searchAction() {
        print("Ищем: \(fromCity) → \(toCity)")
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

