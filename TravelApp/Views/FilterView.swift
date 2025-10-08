import SwiftUI

struct FilterView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedTimes: Set<String> = []
    @State private var allowTransfers: Bool?
    @EnvironmentObject var viewModel: RouteSearchViewModel
    
    var hasSelection: Bool {
        !selectedTimes.isEmpty || allowTransfers != nil
    }
    
    var onApply: ((Set<String>, Bool?) -> Void)?
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 16) {
                Text("Время отправления")
                    .font(.system(size: 24, weight: .bold))
                    .padding(.bottom)
                
                VStack(alignment: .leading, spacing: 32) {
                    
                    filterRow(title: "Утро 6:00 - 12:00")
                    filterRow(title: "День 12:00 - 18:00")
                    filterRow(title: "Вечер 18:00 - 00:00")
                    filterRow(title: "Ночь 00:00 - 06:00")
                }
                .padding(.bottom)
                
                Text("Показывать варианты с пересадками")
                    .font(.system(size: 24, weight: .bold))
                    .padding(.bottom)
                
                VStack(alignment: .leading, spacing: 32) {
                    transferRow(title: "Да", value: true)
                    transferRow(title: "Нет", value: false)
                }
                Spacer()
            }
            if hasSelection {
                VStack {
                    Spacer()
                    Button(action: {
                        viewModel.applyFilters(times: selectedTimes, allowTransfers: allowTransfers)
                        dismiss()
                    }) {
                        Text("Применить")
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
        .padding()
        .listStyle(PlainListStyle())
        .background(Color.white)
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
    }
    private func filterRow(title: String) -> some View {
        Button {
            if selectedTimes.contains(title) {
                selectedTimes.remove(title)
            } else {
                selectedTimes.insert(title)
            }
        } label: {
            HStack {
                Text(title)
                    .font(.system(size: 17, weight: .regular))
                    .foregroundColor(.primary)
                Spacer()
                Image(systemName: selectedTimes.contains(title) ? "checkmark.square.fill" : "square")
                    .foregroundColor(Color("Black_Universal"))
            }
        }
    }
    
    private func transferRow(title: String, value: Bool) -> some View {
        Button {
            allowTransfers = value
        } label: {
            HStack {
                Text(title)
                    .foregroundColor(.primary)
                    .font(.system(size: 17, weight: .regular))
                Spacer()
                Image(systemName: allowTransfers == value ? "largecircle.fill.circle" : "circle")
                    .foregroundColor(Color("Black_Universal"))
            }
        }
    }
}

#Preview {
    FilterView()
}
