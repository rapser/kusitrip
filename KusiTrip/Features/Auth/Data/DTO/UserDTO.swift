import Foundation

nonisolated struct UserDTO: Codable, Sendable {
    let id: String
    let name: String
    let surname: String
    let email: String
    /// ISO-8601 date the account was created.
    let memberSince: String
}
