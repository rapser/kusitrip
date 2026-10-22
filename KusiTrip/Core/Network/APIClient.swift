import Foundation
import Alamofire

nonisolated protocol APIClientProtocol: Sendable {
    func send<Response: Decodable & Sendable>(_ endpoint: Endpoint, as type: Response.Type) async throws -> Response
    func send(_ endpoint: Endpoint) async throws
}

/// `APIClientProtocol` backed by Alamofire. Authenticated endpoints go through
/// the `AuthenticationInterceptor`, which adds the bearer token and refreshes
/// it transparently on 401.
nonisolated final class AlamofireAPIClient: APIClientProtocol {
    private let session: Session
    private let configuration: APIConfiguration
    private let authInterceptor: any RequestInterceptor
    private let decoder = JSONDecoder()

    init(configuration: APIConfiguration, authInterceptor: any RequestInterceptor) {
        let urlConfiguration = URLSessionConfiguration.af.default
        urlConfiguration.timeoutIntervalForRequest = configuration.timeout
        self.session = Session(configuration: urlConfiguration)
        self.configuration = configuration
        self.authInterceptor = authInterceptor
    }

    func send<Response: Decodable & Sendable>(_ endpoint: Endpoint, as type: Response.Type) async throws -> Response {
        let data = try await perform(endpoint)
        do {
            return try decoder.decode(Response.self, from: data)
        } catch {
            throw APIError.decoding
        }
    }

    func send(_ endpoint: Endpoint) async throws {
        _ = try await perform(endpoint)
    }

    private func perform(_ endpoint: Endpoint) async throws -> Data {
        let urlRequest = try endpoint.urlRequest(baseURL: configuration.baseURL)
        let response = await session
            .request(urlRequest, interceptor: endpoint.requiresAuth ? authInterceptor : nil)
            .validate(statusCode: 200..<300)
            .serializingData(emptyResponseCodes: [200, 204, 205])
            .response

        switch response.result {
        case .success(let data):
            return data
        case .failure(let error):
            throw APIError(error: error, statusCode: response.response?.statusCode, data: response.data)
        }
    }
}
