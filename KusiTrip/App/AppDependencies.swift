import Foundation

/// Composition root: builds the shared infrastructure once. Repositories take
/// their dependencies through `init` and default to these instances.
final class AppDependencies {
    static let shared = AppDependencies()

    let configuration: APIConfiguration
    let authSession: AuthSession
    let apiClient: any APIClientProtocol

    private init() {
        configuration = .default
        authSession = AuthSession(configuration: configuration, tokenStore: KeychainTokenStore())
        apiClient = AlamofireAPIClient(configuration: configuration, authInterceptor: authSession.interceptor)
    }
}
