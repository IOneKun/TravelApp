import Foundation

@MainActor
final class ErrorManager: ObservableObject {
    static let shared = ErrorManager()
    
    @Published var networkError: NetworkError?
    
    private init() {}
    
    func handle(error: Error) {
        if let urlError = error as? URLError {
            switch urlError.code {
            case .notConnectedToInternet:
                networkError = .noInternet
            case .timedOut, .cannotFindHost, .cannotConnectToHost, .badServerResponse:
                networkError = .server
            default:
                networkError = .server
            }
        } else {
            networkError = .server
        }
    }
    
    func clear() {
        networkError = nil
    }
}
