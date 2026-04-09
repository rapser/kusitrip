import Foundation

enum AppEvent: Sendable {
    case loginSuccess(userUI: UserUI)
    case loginFailed(message: String)
    case logoutRequested
    case bookingConfirmed(bookingId: String, activityTitle: String)
    case favoriteToggled(activityId: String, isFavorite: Bool)
}
