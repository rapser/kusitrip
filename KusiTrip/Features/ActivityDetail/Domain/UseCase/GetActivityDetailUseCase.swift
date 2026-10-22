import Foundation

struct GetActivityDetailUseCase: Sendable {
    private let repository: any ActivityRepositoryProtocol

    init() {
        self.repository = ActivityRepositoryImpl()
    }

    init(repository: any ActivityRepositoryProtocol) {
        self.repository = repository
    }

    func execute(id: String) async throws -> Activity {
        try await repository.fetchActivity(id: id)
    }

    func related(activityId: String) async throws -> [Activity] {
        try await repository.fetchRelated(activityId: activityId)
    }

    func reviews(activityId: String) async throws -> [Review] {
        try await repository.fetchReviews(activityId: activityId)
    }
}
