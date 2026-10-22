import Foundation

extension Endpoint {
    nonisolated static func login(_ body: LoginRequestDTO) -> Endpoint {
        Endpoint(path: "auth/login", method: .post, body: body)
    }

    nonisolated static func register(_ body: RegisterRequestDTO) -> Endpoint {
        Endpoint(path: "auth/register", method: .post, body: body)
    }

    /// Sends the access token explicitly: logout runs after the local session
    /// has ended, so the auth interceptor no longer has a credential.
    nonisolated static func logout(_ credential: AuthCredential) -> Endpoint {
        Endpoint(
            path: "auth/logout",
            method: .post,
            body: RefreshTokenRequestDTO(refreshToken: credential.refreshToken),
            headers: ["Authorization": "Bearer \(credential.accessToken)"]
        )
    }

    nonisolated static let me = Endpoint(path: "auth/me", requiresAuth: true)
}
