import Foundation

enum UserMapper {
    static func toDomain(dto: UserDTO) -> User {
        let memberSince = ISO8601DateFormatter.kusiAPI.date(from: dto.memberSince)
            .map { String(Calendar.current.component(.year, from: $0)) } ?? ""
        return User(
            id: dto.id,
            email: dto.email,
            name: dto.name,
            surname: dto.surname,
            memberSince: memberSince
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
