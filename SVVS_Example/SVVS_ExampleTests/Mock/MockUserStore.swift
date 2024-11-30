import Testing
import Combine

@testable import SVVS_Example

@MainActor
class MockUserStore: UserStoreProtocol {
    @Published var user: User? = nil
    @Published var error: Error? = nil

    var userPublisher: Published<User?>.Publisher { $user }
    var errorPublisher: Published<Error?>.Publisher { $error }

    private(set) var isLoginCalled = false

    func login(_ userId: String, _ password: String) async {
        isLoginCalled = true
    }
}
