import Testing

@testable import SVVS_Example

@MainActor
final class MockLoginRepository: LoginRepositoryProtocol {
    var isCalledLogin = false
    func login(_ userId: String, _ password: String) async throws -> User {
        isCalledLogin = true
        if userId == "error" {
            throw NetworkError.invalidRequest
        } else {
            return User(id: "test", name: "Test User")
        }
    }

    func logout() async throws -> LogoutResponse {
        return LogoutResponse(result: "Success")
    }
}

@MainActor
struct UserStoreTests {

    @Test func loginに成功した場合userに値が入る() async throws {
        let repository = MockLoginRepository()
        let store = UserStore(repository: repository)
        try await store.login("user_id", "password")
        #expect(repository.isCalledLogin == true)
        #expect(store.user != nil)
    }

    @Test func loginに失敗した場合throwsされる() async {
        let repository = MockLoginRepository()
        let store = UserStore(repository: repository)
        await #expect(throws: NetworkError.self) {
            try await store.login("error", "password")
        }
        #expect(repository.isCalledLogin == true)
        #expect(store.user == nil)
    }
}
