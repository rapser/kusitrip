import Foundation

struct BookingRequest: Sendable {
    let activityId: String
    let activityTitle: String
    let pricePerPerson: Double
    let date: Date
    let numberOfPeople: Int

    var totalPrice: Double { pricePerPerson * Double(numberOfPeople) }
}

struct BookingConfirmation: Sendable, Identifiable {
    let id: String
    let bookingId: String
    let activityTitle: String
    let date: Date
    let numberOfPeople: Int
    let totalPrice: Double
    let confirmedAt: Date
}
