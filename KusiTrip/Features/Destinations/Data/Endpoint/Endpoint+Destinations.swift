import Foundation

extension Endpoint {
    nonisolated static let destinations = Endpoint(path: "destinations")

    nonisolated static func destination(id: String) -> Endpoint {
        Endpoint(path: "destinations/\(id)")
    }

    nonisolated static func destinationActivities(id: String) -> Endpoint {
        Endpoint(path: "destinations/\(id)/activities")
    }
}
