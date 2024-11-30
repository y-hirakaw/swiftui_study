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
}

@MainActor
struct UserStoreTests {

    @Test func loginに成功した場合userに値が入る() async {
        let repository = MockLoginRepository()
        let store = UserStore(repository)
        await store.login("user_id", "password")
        #expect(repository.isCalledLogin == true)
        #expect(store.user != nil)
        #expect(store.error == nil)
    }

    @Test func loginに失敗した場合errorに値が入る() async {
        let repository = MockLoginRepository()
        let store = UserStore(repository)
        await store.login("error", "password")
        #expect(repository.isCalledLogin == true)
        #expect(store.user == nil)
        #expect(store.error != nil)
    }
}
