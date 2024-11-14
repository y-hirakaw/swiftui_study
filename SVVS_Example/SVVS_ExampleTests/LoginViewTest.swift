import Testing
import SwiftUI
import ViewInspector
@testable import SVVS_Example

class MockLoginViewState: LoginViewState {

}

@MainActor
struct LoginViewTest {

    @Test func ログイン前にログインボタンが表示されていること() async throws {
        let mockViewState = MockLoginViewState()
        let view = LoginView(state: mockViewState)
        let button = try view.inspect().find(button: "ログイン")
        #expect(button != nil)
    }

    // TODO: プログレスを取得できない
//    @Test func ログイン中にプログレスが表示されていること() async throws {
//        let mockViewState = MockLoginViewState()
//        mockViewState.loginState = .loggingIn
//        let view = LoginView(state: mockViewState)
//
//        let button = try view.inspect().find(button: "ログイン")
//        #expect(button != nil)
//    }

}
