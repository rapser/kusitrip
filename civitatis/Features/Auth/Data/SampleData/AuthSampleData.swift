import Foundation

enum AuthSampleData {
    static let users: [UserDTO] = [
        UserDTO(
            id: "usr-001",
            email: "usuario@civitatis.com",
            password: "civitatis123",
            name: "Miguel",
            surname: "Tomairo",
            memberSince: "2024"
        ),
        UserDTO(
            id: "usr-002",
            email: "ana@civitatis.com",
            password: "ana1234",
            name: "Ana",
            surname: "García",
            memberSince: "2023"
        )
    ]
}
