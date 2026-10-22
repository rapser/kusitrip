import Foundation

struct BookingRequest: Sendable {
    let activityId: String
    let date: Date
    let numberOfPeople: Int
}

enum BookingStatus: String, Sendable {
    case confirmed
    case cancelled
}

struct BookingConfirmation: Sendable, Identifiable {
    let id: String
    let bookingId: String
    let activityId: String
    let activityTitle: String
    let activityImageURL: String
    let date: Date
    let numberOfPeople: Int
    let totalPrice: Double
    let currency: String
    let status: BookingStatus
    let confirmedAt: Date
}
