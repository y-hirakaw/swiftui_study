import Foundation
import Observation

@Observable
@MainActor
class SearchUsersViewState {
    //    private let store: UserStoreProtocol = .shared
    //    @Dependency(\.userStore) private var userStore
    private let store: UserStore

    /// UserStoreのユーザ一覧をViewBindingする
    var users: SearchUsers? { store.users }
    var errorMessage: String? { store.errorMessage }

    /// 検索バーの文字列
    var searchText: String = "" {
        didSet {
            guard searchText != oldValue else { return }
            debounceSearchTask?.cancel()
            guard !searchText.isEmpty else { return }
            debounceSearchTask = Task {
                try? await Task.sleep(for: .milliseconds(500))
                guard !Task.isCancelled else { return }
                await search()
            }
        }
    }
    /// アラートを表示するか
    var isAlertPresented: Bool = false

    @ObservationIgnored
    private var debounceSearchTask: Task<Void, Never>?

    init(store: UserStore = .shared) {
        self.store = store
    }

    /// 検索バーの値が変わった
    func search() async {
        print("start \(#function)")
        await self.store.searchUsers(query: self.searchText)
        if self.store.errorMessage != nil {
            self.isAlertPresented = true
        }
    }
}
