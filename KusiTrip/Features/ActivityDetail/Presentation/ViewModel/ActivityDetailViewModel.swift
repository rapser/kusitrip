import Foundation

@MainActor
@Observable
final class ActivityDetailViewModel {
    var activity: ActivityUI?
    var relatedActivities: [ActivityUI] = []
    var reviews: [ReviewUI] = []
    var isLoading: Bool = false
    var isDescriptionExpanded: Bool = false
    var currentImageIndex: Int = 0

    private let useCase: GetActivityDetailUseCase

    init() {
        self.useCase = GetActivityDetailUseCase()
    }

    init(useCase: GetActivityDetailUseCase) {
        self.useCase = useCase
    }

    func load(activityId: String) async {
        guard activity == nil else { return }
        isLoading = true
        defer { isLoading = false }
        do {
            let entity = try useCase.execute(id: activityId)
            activity = ActivityMapper.toUI(entity: entity)
            relatedActivities = useCase.related(destinationId: entity.destinationId, excludeId: activityId)
                .map { ActivityMapper.toUI(entity: $0) }
            reviews = useCase.reviews(activityId: activityId)
                .map { ReviewMapper.toUI(entity: $0) }
        } catch {}
    }
}
