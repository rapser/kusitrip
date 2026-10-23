import Foundation

@MainActor
@Observable
final class DestinationDetailViewModel {
    var destination: DestinationUI?
    var activities: [ActivityUI] = []
    var filteredActivities: [ActivityUI] = []
    var selectedCategory: String = "all"
    // True from the start, so the first frame already shows the skeleton.
    var isLoading: Bool = true
    var errorMessage: String?

    var availableCategories: [CategoryUI] {
        var seen = Set<String>()
        var cats: [CategoryUI] = [CategoryUI(id: "all", name: "Todos", icon: "square.grid.2x2")]
        for a in activities {
            if seen.insert(a.categoryId).inserted {
                cats.append(CategoryUI(id: a.categoryId, name: a.categoryLabel, icon: a.categoryIcon))
            }
        }
        return cats
    }

    private let useCase: GetDestinationsUseCase

    init() {
        self.useCase = GetDestinationsUseCase()
    }

    init(useCase: GetDestinationsUseCase) {
        self.useCase = useCase
    }

    func load(destinationId: String) async {
        isLoading = destination == nil
        errorMessage = nil
        defer { isLoading = false }
        do {
            async let dest = useCase.executeDestination(id: destinationId)
            async let rawActs = useCase.executeActivities(for: destinationId)
            destination = DestinationMapper.toUI(entity: try await dest)
            activities = try await rawActs.map { ActivityMapper.toUI(entity: $0) }
            applyFilter()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func selectCategory(_ id: String) {
        selectedCategory = id
        applyFilter()
    }

    private func applyFilter() {
        if selectedCategory == "all" {
            filteredActivities = activities
        } else {
            filteredActivities = activities.filter { $0.categoryId == selectedCategory }
        }
    }
}
