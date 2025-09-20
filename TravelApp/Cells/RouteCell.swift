//import SwiftUI
//
//struct RouteCell: View {
//    let route: RouteModel
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 8) {
//            HStack(alignment: .top) {
//                
//                HStack(spacing: 8) {
//                    AsyncImage(url: URL(string: route.carrierAvatarURL)) { image in
//                        image.resizable()
//                    } placeholder: {
//                        Color.gray
//                    }
//                    .frame(width: 38, height: 38)
//                    .clipShape(Circle())
//
//                    Text(route.carrierName)
//                        .font(.subheadline)
//                        .bold()
//                }
//
//                Spacer()
//
//                Text(route.date, style: .date)
//                    .font(.subheadline)
//            }
//
//            if let transfer = route.transferCity {
//                Text("С пересадкой в \(transfer)")
//                    .font(.footnote)
//                    .foregroundColor(Color("Red_Universal"))
//            }
//
//            HStack {
//                Text(route.departure)
//                Spacer()
//                Text(route.duration)
//                Spacer()
//                Text(route.arrivalTime)
//            }
//            .font(.subheadline)
//        }
//        .padding()
//        .background(Color("Light_Gray"))
//        .cornerRadius(24)
//    }
//}
