import Foundation

nonisolated struct LoginRequestDTO: Encodable, Sendable {
    let email: String
    let password: String
}

nonisolated struct RegisterRequestDTO: Encodable, Sendable {
    let name: String
    let surname: String
    let email: String
    let password: String
}

nonisolated struct RefreshTokenRequestDTO: Encodable, Sendable {
    let refreshToken: String
}

nonisolated struct AuthResponseDTO: Decodable, Sendable {
    let accessToken: String
    let refreshToken: String
    /// Access token lifetime in seconds.
    let expiresIn: Int
    let user: UserDTO

    var credential: AuthCredential {
        AuthCredential(
            accessToken: accessToken,
            refreshToken: refreshToken,
            expiration: Date(timeIntervalSinceNow: TimeInterval(expiresIn))
        )
    }
}
