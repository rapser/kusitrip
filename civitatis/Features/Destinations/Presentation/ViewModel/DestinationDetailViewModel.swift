import Foundation

@MainActor
@Observable
final class DestinationDetailViewModel {
    var destination: DestinationUI?
    var activities: [ActivityUI] = []
    var filteredActivities: [ActivityUI] = []
    var selectedCategory: String = "all"
    var isLoading: Bool = false

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
        isLoading = true
        defer { isLoading = false }
        let dests   = useCase.execute()
        let rawActs = useCase.executeActivities(for: destinationId)
        if let dest = dests.first(where: { $0.id == destinationId }) {
            destination = DestinationMapper.toUI(entity: dest)
        }
        activities = rawActs.map { ActivityMapper.toUI(entity: $0) }
        applyFilter()
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
