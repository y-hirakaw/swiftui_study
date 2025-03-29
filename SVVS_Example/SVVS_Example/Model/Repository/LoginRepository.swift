import Foundation

protocol LoginRepositoryProtocol: Sendable {
    func login(_ userId: String, _ password: String) async throws -> User
    func logout() async throws -> LogoutResponse
}

struct LoginRepository: LoginRepositoryProtocol {

    func login(_ userId: String, _ password: String) async throws -> User {
        try await Task.sleep(nanoseconds: 1_000_000_000) // Simulate 1-second delay
        if Bool.random() {
            throw [NetworkError.serverError, DomainError.invalidCredentials].randomElement()!
        }
        return User(id: "12345", name: "太郎")
    }

    func logout() async throws -> LogoutResponse {
        try await Task.sleep(nanoseconds: 1_000_000_000) // Simulate 1-second delay
        if Bool.random() {
            throw [NetworkError.serverError, DomainError.sessionExpired].randomElement()!
        }
        return LogoutResponse(result: "Success")
    }
}

struct LogoutResponse: Codable {
    let result: String
}
