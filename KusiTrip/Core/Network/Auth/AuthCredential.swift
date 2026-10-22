import Foundation
import Alamofire

nonisolated struct AuthCredential: AuthenticationCredential, Codable, Sendable {
    let accessToken: String
    let refreshToken: String
    let expiration: Date

    /// Refresh a minute early so a request never leaves with a token about to expire.
    var requiresRefresh: Bool { Date(timeIntervalSinceNow: 60) > expiration }
}
