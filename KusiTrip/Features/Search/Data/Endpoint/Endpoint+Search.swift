import Foundation

extension Endpoint {
    nonisolated static func search(query: String) -> Endpoint {
        Endpoint(path: "search", query: ["q": query])
    }
}
