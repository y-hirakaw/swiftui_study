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
        var cancellables: Set<AnyCancellable> = []
        let store = MockUserStore()
        let state = LoginViewState(store: store)
        await confirmation { confirmed in
            await state.didTapLoginButton()
            await withCheckedContinuation { continuation in
                state.$loginState
                    .sink { state in
                        if state == .loggingIn {
                            confirmed()
                            continuation.resume()
                        }
                    }
                    .store(in: &cancellables)
            }
        }
        #expect(store.isLoginCalled == true)
        #expect(state.loginState == .loggingIn)
    }

    @Test func didAppearが呼ばれたら値が更新される() async {
        let store = MockUserStore()
        let state = LoginViewState(store: store)
        await state.didAppear()
        #expect(state.loginState == .notLoggedIn)
        #expect(state.shouldNavigateHome == false)
    }
}
