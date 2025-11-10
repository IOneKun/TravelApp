import SwiftUI

struct CarrierDetailView: View {
    let route: RouteModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                
                if let logoURL = URL(string: route.carrierLogo) {
                    AsyncImage(url: logoURL) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 343, height: 104)
                            .frame(maxWidth: .infinity)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                    } placeholder: {
                        ProgressView()
                            .frame(width: 140, height: 140)
                    }
                } else {
                    Image(systemName: "bus.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.gray)
                }
                
                VStack(alignment: .leading, spacing: 16) {
                    Text(route.carrierName)
                        .font(.system(size: 24, weight: .bold))
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Email")
                            .font(.system(size: 17, weight: .regular))
                            .foregroundColor(Color("Black_Universal"))
                        if let email = route.carrierEmail {
                            Link(email, destination: URL(string: "mailto:\(email)")!)
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.blue)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Телефон")
                            .font(.system(size: 17, weight: .regular))
                            .foregroundColor(Color("Black_Universal"))
                        if let phone = route.carrierPhone {
                            Link(phone, destination: URL(string: "tel:\(phone)")!)
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.blue)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle("Информация о перевозчике")
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(Color("Black_Universal"))
                        .font(.system(size: 20, weight: .medium))
                }
            }
        }
        .background(Color("tabBarColor").ignoresSafeArea())
    }
}

private func formatted(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ru_RU")
    formatter.dateFormat = "d MMM HH:mm"
    return formatter.string(from: date)
}
