import Foundation

extension Endpoint {
    nonisolated static func activity(id: String) -> Endpoint {
        Endpoint(path: "activities/\(id)")
    }

    nonisolated static func relatedActivities(id: String) -> Endpoint {
        Endpoint(path: "activities/\(id)/related")
    }

    nonisolated static func reviews(activityId: String) -> Endpoint {
        Endpoint(path: "activities/\(activityId)/reviews")
    }
}
