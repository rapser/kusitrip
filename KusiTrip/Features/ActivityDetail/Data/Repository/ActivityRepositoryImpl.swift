import Foundation

struct ActivityRepositoryImpl: ActivityRepositoryProtocol {

    func fetchActivity(id: String) throws -> Activity {
        guard let dto = SampleActivities.all.first(where: { $0.id == id }) else {
            throw ActivityError.notFound
        }
        return ActivityMapper.toDomain(dto: dto)
    }

    func fetchRelated(destinationId: String, excludeId: String) -> [Activity] {
        SampleActivities.all
            .filter { $0.destinationId == destinationId && $0.id != excludeId }
            .prefix(4)
            .map { ActivityMapper.toDomain(dto: $0) }
    }

    func fetchReviews(activityId: String) -> [Review] {
        SampleReviews.all
            .filter { $0.activityId == activityId }
            .map { ReviewMapper.toDomain(dto: $0) }
    }
}

enum ActivityError: LocalizedError {
    case notFound
    var errorDescription: String? { "Actividad no encontrada." }
}
