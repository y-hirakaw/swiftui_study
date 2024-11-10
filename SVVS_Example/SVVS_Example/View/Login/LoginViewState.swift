import Combine
import Foundation

@MainActor
class LoginViewState: ObservableObject {
    private let store: UserStore
    /// ログインステータス
    @Published var loginState: LoginState = .notLoggedIn
    /// 入力されたユーザID
    @Published var userId: String = ""
    /// 入力されたパスワード
    @Published var password: String = ""
    /// ホーム画面へ遷移する場合true
    @Published var shouldNavigateHome: Bool = false
    private var cancellables = Set<AnyCancellable>()

    init(store: UserStore = .shared) {
        self.store = store
        self.setupStoreBindings()
    }

    /// Storeプロパティ購読を設定する
    func setupStoreBindings() {
        self.store.$user
            .sink { [weak self] user in
                if user != nil {
                    self?.loginState = .loggedIn
                    self?.shouldNavigateHome = true
                }
            }
            .store(in: &cancellables)
        self.store.$error
            .sink { [weak self] _ in
                // 実際はエラーハンドリングを行う
                self?.loginState = .notLoggedIn
            }
            .store(in: &cancellables)
    }

    /// ログインボタン押下された
    func didTapLoginButton() async {
        Task { @MainActor in
            self.loginState = .loggingIn
        }
        await self.store.login(self.userId, self.password)
    }

    /// 画面が表示された
    func didAppear() async {
        self.loginState = .notLoggedIn
        self.shouldNavigateHome = false
    }
}
