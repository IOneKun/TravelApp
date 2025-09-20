import SwiftUI

struct RouteModel: Identifiable, Hashable {
    let id = UUID()
    let carrierName: String
    let carrierAvatarURL: String
    let date: Date
    let transferCity: String?
    let departure: Date
    let arrival: Date
    let duration: TimeInterval
    let hasTransfers: Bool
}

