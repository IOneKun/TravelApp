import SwiftUI

struct MainView: View {
    @State private var fromCity: String = ""
    @State private var toCity: String = ""
    
    var body: some View {
        NavigationStack {
            TabView {
                VStack {
                    Spacer()
                    VStack(spacing: 0) {
                        NavigationLink {
                            CitySelectionView { selectedCity in
                                fromCity = selectedCity
                            }
                        } label: {
                            HStack {
                                Text(fromCity.isEmpty ? "Откуда" : fromCity)
                                    .foregroundColor(fromCity.isEmpty ? .gray : .black)
                                Spacer()
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(20)
                            .frame(width: 259)
                        }
                        
                        NavigationLink {
                            CitySelectionView { selectedCity in
                                toCity = selectedCity
                            }
                        } label: {
                            HStack {
                                Text(toCity.isEmpty ? "Куда" : toCity)
                                    .foregroundColor(toCity.isEmpty ? .gray : .black)
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
#Preview() {
    MainView()
}
