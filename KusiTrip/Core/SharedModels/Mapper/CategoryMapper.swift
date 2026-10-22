import Foundation

enum CategoryMapper {

    static func toDomain(dto: CategoryDTO) -> Category {
        Category(id: dto.id, name: dto.name, icon: dto.icon)
    }

    static func toUI(entity: Category) -> CategoryUI {
        CategoryUI(id: entity.id, name: entity.name, icon: entity.icon)
    }
}
