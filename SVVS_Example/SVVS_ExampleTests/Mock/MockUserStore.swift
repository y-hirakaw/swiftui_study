import Testing
import Observation

@testable import SVVS_Example

@Observable
@MainActor
class MockUserStore: UserStoreProtocol {
    var user: User? = nil
    var logoutResponse: LogoutResponse? = nil

    var loginError: Error?
    var logoutError: Error?

    private(set) var isLoginCalled = false
    private(set) var isLogoutCalled = false

    func login(_ userId: String, _ password: String) async throws {
        isLoginCalled = true
        if let loginError { throw loginError }
    }

    func logout() async throws {
        isLogoutCalled = true
        if let logoutError { throw logoutError }
    }
}
