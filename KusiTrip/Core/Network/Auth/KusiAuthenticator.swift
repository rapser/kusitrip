import Foundation
import Alamofire

/// Alamofire `Authenticator`: applies the bearer token and rotates it with
/// `POST /auth/refresh`. `AuthenticationInterceptor` guarantees a single
/// refresh at a time and replays the requests that were waiting for it.
nonisolated final class KusiAuthenticator: Authenticator {
    private let configuration: APIConfiguration
    private let tokenStore: any TokenStore
    /// Plain session (no interceptor) so refreshing never recurses into itself.
    private let refreshSession: Session

    init(configuration: APIConfiguration, tokenStore: any TokenStore) {
        self.configuration = configuration
        self.tokenStore = tokenStore
        let urlConfiguration = URLSessionConfiguration.af.default
        urlConfiguration.timeoutIntervalForRequest = configuration.timeout
        self.refreshSession = Session(configuration: urlConfiguration)
    }

    func apply(_ credential: AuthCredential, to urlRequest: inout URLRequest) {
        urlRequest.headers.add(.authorization(bearerToken: credential.accessToken))
    }

    func refresh(
        _ credential: AuthCredential,
        for session: Session,
        completion: @escaping @Sendable (Result<AuthCredential, any Error>) -> Void
    ) {
        let endpoint = Endpoint(
            path: "auth/refresh",
            method: .post,
            body: RefreshTokenRequestDTO(refreshToken: credential.refreshToken)
        )
        guard let request = try? endpoint.urlRequest(baseURL: configuration.baseURL) else {
            completion(.failure(APIError.invalidURL))
            return
        }

        refreshSession.request(request)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: AuthResponseDTO.self) { [tokenStore] response in
                switch response.result {
                case .success(let dto):
                    let newCredential = dto.credential
                    tokenStore.save(newCredential)
                    completion(.success(newCredential))
                case .failure(let error):
                    if response.response?.statusCode == 401 {
                        // The refresh token was revoked or expired: the session is over.
                        tokenStore.clear()
                        Task { await EventBus.shared.send(.sessionExpired) }
                    }
                    completion(.failure(error))
                }
            }
    }

    func didRequest(
        _ urlRequest: URLRequest,
        with response: HTTPURLResponse,
        failDueToAuthenticationError error: any Error
    ) -> Bool {
        response.statusCode == 401
    }

    func isRequest(_ urlRequest: URLRequest, authenticatedWith credential: AuthCredential) -> Bool {
        let bearer = HTTPHeader.authorization(bearerToken: credential.accessToken).value
        return urlRequest.headers["Authorization"] == bearer
    }
}
