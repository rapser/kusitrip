import Foundation

protocol ActivityRepositoryProtocol: Sendable {
    func fetchActivity(id: String) throws -> Activity
    func fetchRelated(destinationId: String, excludeId: String) -> [Activity]
    func fetchReviews(activityId: String) -> [Review]
}
