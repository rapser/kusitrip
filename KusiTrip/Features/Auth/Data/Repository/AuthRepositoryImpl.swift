import Foundation

struct AuthRepositoryImpl: AuthRepositoryProtocol {
    private let apiClient: any APIClientProtocol
    private let session: AuthSession

    init(
        apiClient: any APIClientProtocol = AppDependencies.shared.apiClient,
        session: AuthSession = AppDependencies.shared.authSession
    ) {
        self.apiClient = apiClient
        self.session = session
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
        if let refreshToken = session.credential?.refreshToken {
            // Best effort: the local session ends even if the API cannot be reached.
            try? await apiClient.send(.logout(refreshToken: refreshToken))
        }
        session.end()
    }

    func restoreSession() async -> User? {
        guard session.credential != nil else { return nil }
        do {
            let dto = try await apiClient.send(.me, as: UserDTO.self)
            return UserMapper.toDomain(dto: dto)
        } catch APIError.unauthorized {
            session.end()
            return nil
        } catch {
            // Offline or server down: keep the stored session and retry on next launch.
            return nil
        }
    }

    private func start(with dto: AuthResponseDTO) -> User {
        session.start(with: dto.credential)
        return UserMapper.toDomain(dto: dto.user)
    }
}
