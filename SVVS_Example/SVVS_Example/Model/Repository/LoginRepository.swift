import Foundation

protocol LoginRepositoryProtocol: Sendable {
    func login(_ userId: String, _ password: String) async throws -> User
}

struct LoginRepository: LoginRepositoryProtocol {

    func login(_ userId: String, _ password: String) async throws -> User {
        try await Task.sleep(nanoseconds: 1_000_000_000)
        return User(id: "12345", name: "太郎")
    }
}
