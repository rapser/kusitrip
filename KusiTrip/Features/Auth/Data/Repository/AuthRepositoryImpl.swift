import Foundation

actor AuthRepositoryImpl: AuthRepositoryProtocol {
    private var loggedUser: UserDTO?

    func login(email: String, password: String) async throws -> User {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 800_000_000)
        guard let dto = await AuthSampleData.users.first(where: {
            $0.email == email && $0.password == password
        }) else {
            throw AuthError.invalidCredentials
        }
        loggedUser = dto
        return await UserMapper.toDomain(dto: dto)
    }

    func logout() async {
        loggedUser = nil
    }

    func currentUser() async -> User? {
        guard let dto = loggedUser else { return nil }
        return await UserMapper.toDomain(dto: dto)
    }
}
