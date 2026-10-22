import Foundation

struct ActivityRepositoryImpl: ActivityRepositoryProtocol {
    private let apiClient: any APIClientProtocol

    init(apiClient: any APIClientProtocol = AppDependencies.shared.apiClient) {
        self.apiClient = apiClient
    }

    func fetchActivity(id: String) async throws -> Activity {
        let dto = try await apiClient.send(.activity(id: id), as: ActivityDTO.self)
        return ActivityMapper.toDomain(dto: dto)
    }

    func fetchRelated(activityId: String) async throws -> [Activity] {
        let dtos = try await apiClient.send(.relatedActivities(id: activityId), as: [ActivityDTO].self)
        return dtos.map { ActivityMapper.toDomain(dto: $0) }
    }

    func fetchReviews(activityId: String) async throws -> [Review] {
        let dtos = try await apiClient.send(.reviews(activityId: activityId), as: [ReviewDTO].self)
        return dtos.map { ReviewMapper.toDomain(dto: $0) }
    }
}
