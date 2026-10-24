import Foundation

@MainActor
@Observable
final class ActivityDetailViewModel {
    var activity: ActivityUI?
    var relatedActivities: [ActivityUI] = []
    var reviews: [ReviewUI] = []
    // True from the start, so the first frame already shows the skeleton.
    var isLoading: Bool = true
    var errorMessage: String?
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
        errorMessage = nil
        defer { isLoading = false }
        do {
            async let entity = useCase.execute(id: activityId)
            async let related = useCase.related(activityId: activityId)
            async let reviews = useCase.reviews(activityId: activityId)

            activity = ActivityMapper.toUI(entity: try await entity)
            // Related activities and reviews are secondary: the detail still shows if they fail.
            relatedActivities = ((try? await related) ?? []).map { ActivityMapper.toUI(entity: $0) }
            self.reviews = ((try? await reviews) ?? []).map { ReviewMapper.toUI(entity: $0) }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
