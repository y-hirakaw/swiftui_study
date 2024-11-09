import Combine
import Dependencies
import Foundation

@MainActor
class SearchUsersViewState: ObservableObject {
    //    private let store: UserStoreProtocol = .shared
    //    @Dependency(\.userStore) private var userStore
    private let store: UserStore

    /// UserStoreのユーザ一覧をViewBindingする
    @Published private(set) var users: SearchUsers?
    @Published private(set) var errorMessage: String?

    private var cancellables = Set<AnyCancellable>()

    /// 検索バーの文字列
    @Published var searchText: String = ""
    /// アラートを表示するか
    @Published var isAlertPresented: Bool = false

    init(store: UserStore = .shared) {
        self.store = store
        self.setupStoreBindings()
        self.setupViewBindings()
    }

    func setupStoreBindings() {
        // UserStoreのusersを購読
        self.store.$users
            .assign(to: \.users, on: self)
            .store(in: &cancellables)

        // UserStoreのerrorMessageを購読
        self.store.$errorMessage
            .sink { [weak self] message in
                guard let self else { return }
                self.errorMessage = message
                self.isAlertPresented = message != nil
            }
            .store(in: &cancellables)
    }

    func setupViewBindings() {
        // 検索バーの検索文字
        self.debouncedNonEmpty($searchText)
            .sink { [weak self] _ in
                Task {
                    await self?.search()
                }
            }
            .store(in: &cancellables)
    }

    /// 検索バーの値が変わった
    func search() async {
        print("start \(#function)")
        await self.store.searchUsers(query: self.searchText)
    }

    /// `searchText` にデバウンス、フィルタ、重複除去を適用したPublisherを返す関数
    private func debouncedNonEmpty(_ publisher: Published<String>.Publisher)
        -> AnyPublisher<String, Never>
    {
        publisher
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)  // デバウンス
            .filter { !$0.isEmpty }  // 空文字をフィルタ
            .removeDuplicates()  // 重複削除
            .eraseToAnyPublisher()
    }
}
