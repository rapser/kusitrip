import Foundation

@MainActor
@Observable
final class HomeViewModel {
    var destinations: [DestinationUI] = []
    var featuredActivities: [ActivityUI] = []
    var categories: [CategoryUI] = []
    var isLoading: Bool = false
    var errorMessage: String?

    private let useCase: GetHomeDataUseCase

    init() {
        self.useCase = GetHomeDataUseCase()
    }

    init(useCase: GetHomeDataUseCase) {
        self.useCase = useCase
    }

    func load() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        let data = useCase.execute()
        destinations       = data.destinations.map { DestinationMapper.toUI(entity: $0) }
        featuredActivities = data.featuredActivities.map { ActivityMapper.toUI(entity: $0) }
        categories         = data.categories.map { CategoryMapper.toUI(entity: $0) }
    }
}
