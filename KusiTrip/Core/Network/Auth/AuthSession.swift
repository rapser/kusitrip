import Foundation
import Alamofire

/// Owns the current credential: keeps the Keychain and the Alamofire
/// interceptor in sync when a session starts or ends.
nonisolated final class AuthSession: Sendable {
    let interceptor: AuthenticationInterceptor<KusiAuthenticator>
    private let tokenStore: any TokenStore

    init(configuration: APIConfiguration, tokenStore: any TokenStore) {
        self.tokenStore = tokenStore
        self.interceptor = AuthenticationInterceptor(
            authenticator: KusiAuthenticator(configuration: configuration, tokenStore: tokenStore),
            credential: tokenStore.load()
        )
    }

    var credential: AuthCredential? { interceptor.credential }

    func start(with credential: AuthCredential) {
        tokenStore.save(credential)
        interceptor.credential = credential
    }

    func end() {
        tokenStore.clear()
        interceptor.credential = nil
    }
}
