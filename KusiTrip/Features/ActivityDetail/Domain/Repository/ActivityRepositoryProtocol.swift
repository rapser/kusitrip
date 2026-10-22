import Foundation

protocol ActivityRepositoryProtocol: Sendable {
    func fetchActivity(id: String) async throws -> Activity
    func fetchRelated(activityId: String) async throws -> [Activity]
    func fetchReviews(activityId: String) async throws -> [Review]
}
