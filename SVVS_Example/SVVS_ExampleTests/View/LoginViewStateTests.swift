import Testing
import Combine

@testable import SVVS_Example

@MainActor
struct LoginViewStateTests {

    @Test func didTapLoginButtonでloginが呼ばれる() async {
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

    @Test func didAppearで値が更新される() async {
        let store = MockUserStore()
        let state = LoginViewState(store: store)
        await state.didAppear()
        #expect(state.loginState == .notLoggedIn)
        #expect(state.shouldNavigateHome == false)
    }
}
