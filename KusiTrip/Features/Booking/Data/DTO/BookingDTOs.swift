import Foundation

nonisolated struct CreateBookingRequestDTO: Encodable, Sendable {
    let activityId: String
    /// ISO-8601 date and time of the activity.
    let date: String
    let numberOfPeople: Int
}

nonisolated struct BookingDTO: Decodable, Sendable {
    let id: String
    let bookingNumber: String
    let activityId: String
    let activityTitle: String
    let activityImageUrl: String
    let date: String
    let numberOfPeople: Int
    let unitPrice: Double
    let totalPrice: Double
    let currency: String
    let status: String
    let confirmedAt: String
}
