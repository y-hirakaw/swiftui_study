import Testing
import SwiftUI

@testable import SVVS_Example

class MockLoginViewState: LoginViewStateProtocol {
    var loginState: SVVS_Example.LoginState = .notLoggedIn

    var userId: String = ""

    var password: String = ""

    var shouldNavigateHome: Bool = false

    func didTapLoginButton() async {
    }

    func didAppear() async {
    }

}

@MainActor
struct LoginViewTest {

//    @Test func ログイン前にログインボタンが表示されていること() async throws {
//        let mockViewState = MockLoginViewState()
//        let view = LoginView(state: mockViewState)
//    }
//
//    @Test func ログイン中にプログレスが表示されていること() async throws {
//        let mockViewState = MockLoginViewState()
//        mockViewState.loginState = .loggingIn
//        let view = LoginView(state: mockViewState)
//    }

}
