//import SwiftUI
//
//struct SearchResultView: View {
//    @Environment(\.dismiss) private var dismiss
//    let fromCity: String
//    let toCity: String
//    let routes: [RouteModel]
//    
//    var body: some View {
//        VStack(spacing: 16) {
//            HStack {
//                Button(action: {
//                    dismiss()
//                }) {
//                    Image(systemName: "chevron.left")
//                        .foregroundColor(.black)
//                        .font(.system(size: 20, weight: .medium))
//                }
//                Spacer()
//            }
//            HStack(spacing: 4) {
//                Text(fromCity)
//                    .font(.headline)
//                Image(systemName: "arrow.right")
//                Text(toCity)
//                    .font(.headline)
//            }
//            
//            ScrollView {
//                LazyVGrid(columns: [GridItem(.flexible())], spacing: 16) {
//                    ForEach(routes) { route in
//                        RouteCell(route: route)
//                            .frame(height: 104)
//                    }
//                }
//                .padding() 
//            }
//        }
//    }
//}
//
//
