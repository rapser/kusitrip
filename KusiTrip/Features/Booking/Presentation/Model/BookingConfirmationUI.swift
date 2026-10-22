import Foundation

struct BookingConfirmationUI: Sendable, Identifiable, Hashable {
    let id: String
    let bookingId: String
    let activityTitle: String
    let activityImageURL: String
    let formattedDate: String
    let formattedTime: String
    let numberOfPeopleText: String
    let formattedTotal: String
    let confirmedAt: String
    let isCancelled: Bool
    let isUpcoming: Bool
}
