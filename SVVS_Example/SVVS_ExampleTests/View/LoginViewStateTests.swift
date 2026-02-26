import Testing

@testable import SVVS_Example

@MainActor
struct LoginViewStateTests {

    @Test func didTapLoginButtonでloginが呼ばれ失敗時はnotLoggedInになる() async {
        let store = MockUserStore()
        store.loginError = NetworkError.invalidRequest
        let state = LoginViewState(store: store)
        await state.didTapLoginButton()
        #expect(store.isLoginCalled == true)
        #expect(state.loginState == .notLoggedIn)
    }

    @Test func didTapLoginButtonでlogin成功時にloggedInになる() async {
        let store = MockUserStore()
        let state = LoginViewState(store: store)
        await state.didTapLoginButton()
        #expect(store.isLoginCalled == true)
        #expect(state.loginState == .loggedIn)
        #expect(state.shouldNavigateHome == true)
    }

    @Test func didAppearで値が更新される() async {
        let store = MockUserStore()
        let state = LoginViewState(store: store)
        await state.didAppear()
        #expect(state.loginState == .notLoggedIn)
        #expect(state.shouldNavigateHome == false)
    }
}
