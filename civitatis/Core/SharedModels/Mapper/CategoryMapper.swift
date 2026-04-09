import Foundation

enum CategoryMapper {

    static var allCategories: [Category] {
        [.all, .guided, .excursions, .tickets, .gastronomy, .transport, .boat, .free]
    }

    static func toDomain(dto: CategoryDTO) -> Category {
        Category(id: dto.id, name: dto.name, icon: dto.icon)
    }

    static func toUI(entity: Category) -> CategoryUI {
        CategoryUI(id: entity.id, name: entity.name, icon: entity.icon)
    }

    static var allCategoriesUI: [CategoryUI] {
        allCategories.map { toUI(entity: $0) }
    }
}
