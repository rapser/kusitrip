import Foundation

nonisolated enum AppEvent: Sendable {
    case loginSuccess(userUI: UserUI)
    case loginFailed(message: String)
    case logoutRequested
    /// The refresh token was rejected by the API; the user must log in again.
    case sessionExpired
    case bookingConfirmed(bookingId: String, activityTitle: String)
    case favoriteToggled(activityId: String, isFavorite: Bool)
}
