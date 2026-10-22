import Foundation
import Alamofire

/// Describes one call to the KusiTrip API. Each feature declares its own
/// endpoints in its Data layer (e.g. `Endpoint.home`).
nonisolated struct Endpoint: Sendable {
    /// Own HTTP verb type so features never import Alamofire.
    enum Method: String, Sendable {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case patch = "PATCH"
        case delete = "DELETE"
    }

    let path: String
    let method: Method
    let query: [String: String]
    let body: (any Encodable & Sendable)?
    let headers: [String: String]
    let requiresAuth: Bool

    init(
        path: String,
        method: Method = .get,
        query: [String: String] = [:],
        body: (any Encodable & Sendable)? = nil,
        headers: [String: String] = [:],
        requiresAuth: Bool = false
    ) {
        self.path = path
        self.method = method
        self.query = query
        self.body = body
        self.headers = headers
        self.requiresAuth = requiresAuth
    }

    func urlRequest(baseURL: URL) throws -> URLRequest {
        guard var components = URLComponents(
            url: baseURL.appending(path: path),
            resolvingAgainstBaseURL: false
        ) else {
            throw APIError.invalidURL
        }
        if !query.isEmpty {
            components.queryItems = query
                .sorted { $0.key < $1.key }
                .map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        guard let url = components.url else { throw APIError.invalidURL }

        var request = URLRequest(url: url)
        request.method = HTTPMethod(rawValue: method.rawValue)
        request.headers.add(.accept("application/json"))
        request.headers.add(.acceptLanguage("es"))
        for (name, value) in headers {
            request.headers.add(name: name, value: value)
        }
        if let body {
            request.httpBody = try JSONEncoder().encode(body)
            request.headers.add(.contentType("application/json"))
        }
        return request
    }
}
