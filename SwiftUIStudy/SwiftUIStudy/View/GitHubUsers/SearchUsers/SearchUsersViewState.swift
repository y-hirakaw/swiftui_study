import Foundation
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

        // 空文字ではないかつ、0.5秒変化がなければ検索を実行する
        self.$searchText
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .filter { !$0.isEmpty }
            .sink { [weak self] text in
                Task {
                    await self?.search()
                }
            }
            .store(in: &cancellables)
    }

    /// 検索バーの値が変わった
    func search() async {
        await self.store.searchUsers(query: self.searchText)
    }
}
