import Foundation
import Observation

@MainActor
protocol LoginViewStateProtocol: AnyObject {
    var loginState: LoginState { get set }
    var userId: String { get set }
    var password: String { get set }
    var shouldNavigateHome: Bool { get set }

    func didTapLoginButton() async
    func didAppear() async
}

@Observable
@MainActor
class LoginViewState: LoginViewStateProtocol {
    private let store: any UserStoreProtocol
    /// ログインステータス
    var loginState: LoginState = .notLoggedIn
    /// 入力されたユーザID
    var userId: String = ""
    /// 入力されたパスワード
    var password: String = ""
    /// ホーム画面へ遷移する場合true
    var shouldNavigateHome: Bool = false

    init(store: any UserStoreProtocol = UserStore.shared) {
        self.store = store
    }

    /// ログインボタン押下された
    func didTapLoginButton() async {
        self.loginState = .loggingIn
        do {
            try await self.store.login(self.userId, self.password)
            self.loginState = .loggedIn
            self.shouldNavigateHome = true
        } catch {
            self.loginState = .notLoggedIn
        }
    }

    /// 画面が表示された
    func didAppear() async {
        self.loginState = .notLoggedIn
        self.shouldNavigateHome = false
    }
}
