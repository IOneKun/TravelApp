import SwiftUI
let exampleRoute = RouteModel(
    fromTitle: "Москва",
    toTitle: "Казань",
    departure: Date(),
    arrival: Date().addingTimeInterval(5*3600),
    carrierName: "РЖД",
    carrierLogo: "",
    duration: 50,
    transferCity: nil
)

let timeFormatter: DateFormatter = {
    let f = DateFormatter()
    f.locale = Locale(identifier: "ru_RU")
    f.dateFormat = "HH:mm"
    return f
}()
struct RouteCell: View {
    let route: RouteModel
   
    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(alignment: .top) {
                
                HStack(alignment: .center, spacing: 8) {
                    if let url = URL(string: route.carrierLogo), !route.carrierLogo.isEmpty {
                        AsyncImage(url: url) { image in
                            image.resizable()
                                .scaledToFit()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 40, height: 40)
                    } else {
                        Image(systemName: "tram")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 38, height: 38)
                            .foregroundColor(.black)
                    }
                    Text(route.carrierName)
                        .font(.system(size: 17, weight: .regular))
                        
                }
                
                Spacer()
                
                Text(route.date.toUIDateString())
                    .font(.system(size: 12, weight: .regular))
            }
            
            if let transfer = route.transferCity {
                Text("С пересадкой в \(transfer)")
                    .font(.footnote)
                    .foregroundColor(Color("Red_Universal"))
            }
            
            HStack(alignment: .center) {
                Text(timeFormatter.string(from: route.arrival))
                Spacer()
                ZStack {
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(Color("Gray_Universal"))
                        
                        Text(formatDuration(route.duration))
                            .font(.footnote)
                            .padding(.horizontal, 8)
                            .background(Color("Light_Gray"))
                    }
                    
                Text(timeFormatter.string(from: route.departure))
            }
            .font(.subheadline)
        }
        .padding()
        .background(Color("Light_Gray"))
        .cornerRadius(24)
    }
}

func formatDuration(_ seconds: Int) -> String {
    let hours = seconds / 3600
    let minutes = (seconds % 3600) / 60
    if hours > 0 {
        return "\(hours) ч \(minutes) мин"
    } else {
        return "\(minutes) мин"
    }
}
#Preview {
    RouteCell(route: exampleRoute)
}
