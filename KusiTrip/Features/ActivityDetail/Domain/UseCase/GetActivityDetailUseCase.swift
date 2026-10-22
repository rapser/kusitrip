import Foundation

struct GetActivityDetailUseCase: Sendable {
    private let repository: any ActivityRepositoryProtocol

    init() {
        self.repository = ActivityRepositoryImpl()
    }

    init(repository: any ActivityRepositoryProtocol) {
        self.repository = repository
    }

    func execute(id: String) throws -> Activity {
        try repository.fetchActivity(id: id)
    }

    func related(destinationId: String, excludeId: String) -> [Activity] {
        repository.fetchRelated(destinationId: destinationId, excludeId: excludeId)
    }

    func reviews(activityId: String) -> [Review] {
        repository.fetchReviews(activityId: activityId)
    }
}
