import Foundation

enum AuthSampleData {
    static let users: [UserDTO] = [
        UserDTO(
            id: "usr-001",
            email: "usuario@kusitrip.com",
            password: "kusitrip123",
            name: "Miguel",
            surname: "Tomairo",
            memberSince: "2024"
        ),
        UserDTO(
            id: "usr-002",
            email: "ana@kusitrip.com",
            password: "ana1234",
            name: "Ana",
            surname: "García",
            memberSince: "2023"
        )
    ]
}
