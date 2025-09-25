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
}
