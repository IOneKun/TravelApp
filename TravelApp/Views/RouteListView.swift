import SwiftUI
import OpenAPIRuntime
import OpenAPIURLSession

struct RouteListView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    let from: StationUI
    let to: StationUI
    let date: String

    @StateObject private var viewModel: RouteSearchViewModel

    init(
        from: StationUI,
        to: StationUI,
        date: String = Date().toAPIDateString(),
        betweenStationsService: ScheduleBetweenStationsProtocol,
        carrierService: CarrierServiceProtocol
    ) {
        self.from = from
        self.to = to
        self.date = date
        _viewModel = StateObject(
            wrappedValue: RouteSearchViewModel(
                betweenStationsService: betweenStationsService,
                carrierService: carrierService
            )
        )
    }

    var body: some View {
        VStack(spacing: 16) {
            
            Text("\(from.name) → \(to.name)")
                .font(.system(size: 24, weight: .bold))
                .bold()
                .lineLimit(nil)
                .padding(.leading)
                .padding(.trailing)
            
            if viewModel.isLoading {
                ProgressView("Загрузка маршрутов…")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding()
            } else if viewModel.routes.isEmpty {
                Text("Вариантов нет")
                    .font(.system(size: 24, weight: .bold))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    LazyVStack(spacing: 8) {
                        ForEach(viewModel.routes) { route in
                            RouteCell(route: route)
                        }
                    }
                    .padding(.trailing)
                    .padding(.leading)
                }
            }
        }
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
            await viewModel.searchRoutes(from: from.id, to: to.id, date: date)
        }
    }
}


extension Date {
    func toAPIDateString() -> String {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withFullDate]
        return dateFormatter.string(from: self)
    }
    func toUIDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "d MMMM"
        return dateFormatter.string(from: self) 
    }
}
