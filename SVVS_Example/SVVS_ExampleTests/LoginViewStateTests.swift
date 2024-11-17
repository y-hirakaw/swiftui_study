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

@MainActor
struct LoginViewStateTests {

    @Test func didTapLoginButtonが呼ばれたらloginが呼ばれる() async {
        let store = MockUserStore()
        let state = LoginViewState(store: store)
        await state.didTapLoginButton()
        #expect(store.isLoginCalled == true)
        // TODO: Taskで変更している都合でテストできない
//        #expect(state.loginState == .loggingIn)
    }

    @Test func didAppearが呼ばれたら値が更新される() async {
        let store = MockUserStore()
        let state = LoginViewState(store: store)
        await state.didAppear()
        #expect(state.loginState == .notLoggedIn)
        #expect(state.shouldNavigateHome == false)
    }
}
