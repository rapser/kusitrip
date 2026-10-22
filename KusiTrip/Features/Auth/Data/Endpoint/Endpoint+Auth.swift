import Foundation

extension Endpoint {
    nonisolated static func login(_ body: LoginRequestDTO) -> Endpoint {
        Endpoint(path: "auth/login", method: .post, body: body)
    }

    nonisolated static func register(_ body: RegisterRequestDTO) -> Endpoint {
        Endpoint(path: "auth/register", method: .post, body: body)
    }

    nonisolated static func logout(refreshToken: String) -> Endpoint {
        Endpoint(
            path: "auth/logout",
            method: .post,
            body: RefreshTokenRequestDTO(refreshToken: refreshToken),
            requiresAuth: true
        )
    }

    nonisolated static let me = Endpoint(path: "auth/me", requiresAuth: true)
}
