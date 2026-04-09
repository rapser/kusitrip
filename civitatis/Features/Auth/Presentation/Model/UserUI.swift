import Foundation

struct UserUI: Sendable, Identifiable, Hashable {
    let id: String
    let email: String
    let fullName: String
    let initials: String
    let memberSince: String
}
