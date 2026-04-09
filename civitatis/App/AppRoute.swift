import Foundation

enum AppRoute: Hashable {
    case destinationDetail(id: String)
    case activityDetail(id: String)
    case booking(activityId: String)
    case bookingConfirmation(bookingId: String, activityTitle: String, totalPrice: Double)
}
