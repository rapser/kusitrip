import Foundation

struct User: Sendable, Identifiable, Hashable {
    let id: String
    let email: String
    let name: String
    let surname: String
    let memberSince: String

    var fullName: String { "\(name) \(surname)" }

    var initials: String {
        [name, surname]
            .compactMap { $0.first.map(String.init) }
            .joined()
            .uppercased()
    }
}

enum AuthError: LocalizedError {
    case invalidCredentials
    case emptyFields

    var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            return "Email o contraseña incorrectos. Por favor, inténtalo de nuevo."
        case .emptyFields:
            return "Por favor, introduce tu email y contraseña."
        }
    }
}
