import Foundation

struct BookingConfirmationUI: Sendable, Identifiable {
    let id: String
    let bookingId: String
    let activityTitle: String
    let formattedDate: String
    let formattedTime: String
    let numberOfPeopleText: String
    let formattedTotal: String
    let confirmedAt: String
}
