import Combine

@MainActor
final class SearchUsersViewState: ObservableObject {
    private let store: UserStore = .shared

    /// UserStoreのユーザ一覧をViewBindingする
    @Published private(set) var users: SearchUsers?

    private var cancellables = Set<AnyCancellable>()

    /// 検索バーの文字列
    @Published var searchText: String = ""

    init() {
        // UserStoreのusersを購読
        self.store.$users
            .assign(to: \.users, on: self)
            .store(in: &cancellables)
    }

    /// 検索バーの値が変わった
    func search() async {
        await self.store.searchUsers(query: self.searchText)
    }
}
