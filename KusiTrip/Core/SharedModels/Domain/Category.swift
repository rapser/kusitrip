import Foundation

struct Category: Sendable, Identifiable, Hashable {
    let id: String
    let name: String
    let icon: String

    /// Client-side "no filter" option; the API only returns real categories.
    static let all = Category(id: "all", name: "Todos", icon: "square.grid.2x2")
}
