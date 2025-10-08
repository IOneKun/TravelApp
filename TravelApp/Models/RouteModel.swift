import SwiftUI
import Foundation

struct RouteModel: Identifiable, Hashable {
    let id = UUID()
    let fromTitle: String
    let toTitle: String
    let departure: Date
    let arrival: Date
    let carrierName: String
    let carrierLogo: String
    let duration: Int
    let date = Date()
    var transferCity: String?
    
    let hasTransfer: Bool
    
    
    var timeCategory: String {
        let msk = TimeZone(secondsFromGMT: 3 * 3600)! 
        var calendar = Calendar.current
        calendar.timeZone = msk
        
        let hour = calendar.component(.hour, from: departure)
        let minute = calendar.component(.minute, from: departure)
        let totalMinutes = hour * 60 + minute
        
        switch totalMinutes {
        case 360..<720:
            return "Утро 6:00 - 12:00"
        case 720..<1080:
            return "День 12:00 - 18:00"
        case 1080..<1440:
            return "Вечер 18:00 - 00:00"
        default:
            return "Ночь 0:00 - 6:00"
        }
    }
}

