import Foundation
import Alamofire

nonisolated enum APIError: LocalizedError, Sendable, Equatable {
    /// Error envelope returned by the API: `{ error: { code, message, ... } }`.
    case server(code: String, message: String, statusCode: Int)
    case unauthorized
    case noConnection
    case timeout
    case decoding
    case invalidURL
    case unknown

    init(error: AFError, statusCode: Int?, data: Data?) {
        if let data, let envelope = try? JSONDecoder().decode(ErrorEnvelope.self, from: data) {
            self = .server(
                code: envelope.error.code,
                message: envelope.error.message,
                statusCode: statusCode ?? 0
            )
            return
        }
        if statusCode == 401 {
            self = .unauthorized
            return
        }
        switch (error.underlyingError as? URLError)?.code {
        case .notConnectedToInternet, .networkConnectionLost, .cannotConnectToHost:
            self = .noConnection
        case .timedOut:
            self = .timeout
        default:
            self = error.isResponseSerializationError ? .decoding : .unknown
        }
    }

    var errorDescription: String? {
        switch self {
        case .server(_, let message, _):
            return message
        case .unauthorized:
            return "Tu sesión expiró. Inicia sesión de nuevo."
        case .noConnection:
            return "No hay conexión a internet. Revisa tu red e inténtalo de nuevo."
        case .timeout:
            return "El servidor tardó demasiado en responder. Inténtalo de nuevo."
        case .decoding, .invalidURL, .unknown:
            return "Ocurrió un error inesperado. Inténtalo de nuevo más tarde."
        }
    }
}

private nonisolated struct ErrorEnvelope: Decodable {
    struct Body: Decodable {
        let code: String
        let message: String
    }

    let error: Body
}
