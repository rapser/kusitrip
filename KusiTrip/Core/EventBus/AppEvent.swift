import Foundation

nonisolated enum AppEvent: Sendable {
    case loginSuccess(userUI: UserUI)
    case loginFailed(message: String)
    /// The user confirmed logout; shown with a full-screen loader until `.logoutRequested`.
    case logoutStarted
    case logoutRequested
    /// The refresh token was rejected by the API; the user must log in again.
    case sessionExpired
    case bookingConfirmed(bookingId: String, activityTitle: String)
    case favoriteToggled(activityId: String, isFavorite: Bool)
}
