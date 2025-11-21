import SwiftUI

enum RouteListDestination: Hashable {
    case filter
    case carrier(RouteModel)
}

struct RouteListView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    let from: StationUI
    let to: StationUI
    let date: String
    
    @Binding var path: NavigationPath
    
    @ObservedObject private var errorManager = ErrorManager.shared
    @StateObject var viewModel: RouteSearchViewModel
    
    var body: some View {
        ZStack {
            Color("tabBarColor")
                .ignoresSafeArea()
                .zIndex(0)

            VStack(spacing: 16) {
                
                Text("\(from.name) → \(to.name)")
                    .font(.system(size: 24, weight: .bold))
                    .lineLimit(nil)
                    .padding(.horizontal)
                
                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)

                } else if viewModel.filteredRoutes.isEmpty {
                    Text("Вариантов нет")
                        .font(.system(size: 24, weight: .bold))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)

                } else {
                    ScrollView {
                        LazyVStack(spacing: 8) {
                            ForEach(viewModel.filteredRoutes) { route in
                                Button {
                                    path.append(RouteListDestination.carrier(route))
                                } label: {
                                    RouteCell(route: route)
                                        .contentShape(Rectangle())
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal)
                    }
                    .overlay(alignment: .bottom) {
                        Button {
                            path.append(RouteListDestination.filter)
                        } label: {
                            Text("Уточнить время")
                                .font(.system(size: 17, weight: .bold))
                                .foregroundColor(Color("White_Universal"))
                                .frame(maxWidth: .infinity, minHeight: 60, maxHeight: 60)
                                .background(Color("Blue_Universal"))
                                .cornerRadius(16)
                                .padding(.horizontal)
                        }
                    }
                }
            }

            if let error = errorManager.networkError {
                NetworkStatusView(error: error)
                    .transition(.opacity)
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(Color("Black_Universal"))
                }
            }
        }
        .task {
            await viewModel.searchRoutes(from: from.id, to: to.id, date: date)
        }
        .navigationDestination(for: RouteListDestination.self) { destination in
            switch destination {
            case .filter:
                FilterView()
                    .environmentObject(viewModel)

            case .carrier(let route):
                CarrierDetailView(route: route)
            }
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
        dateFormatter.timeZone = TimeZone(identifier: "Europe/Moscow")
        return dateFormatter.string(from: self)
    }
}

