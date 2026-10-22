import Foundation

struct SearchResult: Sendable {
    let activities: [Activity]
    let destinations: [Destination]

    static let empty = SearchResult(activities: [], destinations: [])
}
