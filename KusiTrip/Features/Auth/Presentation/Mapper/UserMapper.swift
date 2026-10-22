import Foundation

enum UserMapper {
    static func toDomain(dto: UserDTO) -> User {
        User(
            id: dto.id,
            email: dto.email,
            name: dto.name,
            surname: dto.surname,
            memberSince: dto.memberSince
        )
    }

    static func toUI(entity: User) -> UserUI {
        UserUI(
            id: entity.id,
            email: entity.email,
            fullName: entity.fullName,
            initials: entity.initials,
            memberSince: entity.memberSince
        )
    }
}
