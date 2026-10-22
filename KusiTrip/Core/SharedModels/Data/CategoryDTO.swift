import Foundation

nonisolated struct CategoryDTO: Decodable, Sendable {
    let id: String
    let name: String
    let icon: String
}
