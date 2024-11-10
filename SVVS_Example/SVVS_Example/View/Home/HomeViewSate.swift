import Combine
import Foundation

@MainActor
class HomeViewState: ObservableObject {
    private let store: UserStore
    @Published var user: User?

    private var cancellables = Set<AnyCancellable>()

    init(store: UserStore = .shared) {
        self.store = store
        self.setupStoreBindings()
    }

    /// Storeプロパティ購読を設定する
    func setupStoreBindings() {
        self.store.$user
            .sink { [weak self] user in
                self?.user = user
            }
            .store(in: &cancellables)
    }

    /// ユーザ名付きの挨拶文字列
    var userGreeting: String {
        guard let user else { return "名前が取得できません" }
        return "こんにちは \(user.name)さん"
    }
}
