import Foundation

enum NetworkError: Error {
    case server
    case noInternet
    
    var message: String {
        switch self {
        case .server:
            return "Ошибка сервера"
        case .noInternet:
            return "Нет интернета"
        }
    }
}

