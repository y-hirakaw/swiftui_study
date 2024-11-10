import Combine
import Foundation

@MainActor
class LoginViewState: ObservableObject {
    private let store: UserStore
    @Published var userId: String = ""
    @Published var password: String = ""
    @Published var errorMessage: String?
    /// アラートを表示するか
    @Published var isAlertPresented: Bool = false
    private var cancellables = Set<AnyCancellable>()

    init(store: UserStore = .shared) {
        self.store = store
        self.setupStoreBindings()
        self.setupViewBindings()
    }

    func setupStoreBindings() {
        // UserStoreのerrorMessageを購読
        self.store.$error
            .sink { [weak self] error in
                guard let self else { return }
                self.errorMessage = error?.localizedDescription
                self.isAlertPresented = error != nil
            }
            .store(in: &cancellables)
    }

    func setupViewBindings() {
    }

    /// ログインボタン押下
    func didTapLoginButton() async {
        print("start \(#function)")
        await self.store.login(self.userId, self.password)
    }
}
