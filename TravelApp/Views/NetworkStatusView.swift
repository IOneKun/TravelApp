import SwiftUI

struct NetworkStatusView: View {
    let error: NetworkError
    
    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            Image(error == .server ? "server_error" : "no_internet")
                .resizable()
                .scaledToFit()
                .frame(width: 220, height: 220)
            Text(error.message)
                .font(.system(size: 20, weight: .bold))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("White_Universal").ignoresSafeArea())
    }
}

