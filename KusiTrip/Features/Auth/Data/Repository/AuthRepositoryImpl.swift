import Foundation

struct AuthRepositoryImpl: AuthRepositoryProtocol {
    private let apiClient: any APIClientProtocol
    private let session: AuthSession
    private let userCache: any UserCache

    init(
        apiClient: any APIClientProtocol = AppDependencies.shared.apiClient,
        session: AuthSession = AppDependencies.shared.authSession,
        userCache: any UserCache = KeychainUserCache()
    ) {
        self.apiClient = apiClient
        self.session = session
        self.userCache = userCache
    }

    func login(email: String, password: String) async throws -> User {
        do {
            let dto = try await apiClient.send(
                .login(LoginRequestDTO(email: email, password: password)),
                as: AuthResponseDTO.self
            )
            return start(with: dto)
        } catch APIError.server(code: "INVALID_CREDENTIALS", _, _) {
            throw AuthError.invalidCredentials
        }
    }

    func register(name: String, surname: String, email: String, password: String) async throws -> User {
        let dto = try await apiClient.send(
            .register(RegisterRequestDTO(name: name, surname: surname, email: email, password: password)),
            as: AuthResponseDTO.self
        )
        return start(with: dto)
    }

    func logout() async {
        let credential = session.credential
        session.end()
        userCache.clear()
        guard let credential else { return }
        // Revoke the refresh token in the background: the user never waits for
        // the API (a cold start on Render can take over a minute). Best effort.
        Task { [apiClient] in
            try? await apiClient.send(.logout(credential))
        }
    }

    func cachedUser() -> User? {
        guard session.credential != nil, let dto = userCache.load() else { return nil }
        return UserMapper.toDomain(dto: dto)
    }

    func restoreSession() async -> User? {
        guard session.credential != nil else { return nil }
        do {
            let dto = try await apiClient.send(.me, as: UserDTO.self)
            userCache.save(dto)
            return UserMapper.toDomain(dto: dto)
        } catch APIError.unauthorized {
            session.end()
            userCache.clear()
            // The app may already be showing the cached user: send it back to login.
            await EventBus.shared.send(.sessionExpired)
            return nil
        } catch {
            // Offline or server down: keep the stored session and retry on next launch.
            return nil
        }
    }

    private func start(with dto: AuthResponseDTO) -> User {
        session.start(with: dto.credential)
        userCache.save(dto.user)
        return UserMapper.toDomain(dto: dto.user)
    }
}
