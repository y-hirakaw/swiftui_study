import Foundation
import Combine

@MainActor
final class SearchUsersViewState: ObservableObject {
    private let store: UserStore = .shared

    /// UserStoreのユーザ一覧をViewBindingする
    @Published private(set) var users: SearchUsers?
    @Published private(set) var errorMessage: String?

    private var cancellables = Set<AnyCancellable>()

    /// 検索バーの文字列
    @Published var searchText: String = ""
    @Published var isAlertPresented: Bool = false

    init() {
        // UserStoreのusersを購読
        self.store.$users
            .assign(to: \.users, on: self)
            .store(in: &cancellables)

//        self.store.$errorMessage
//            .assign(to: \.errorMessage, on: self)
//            .store(in: &cancellables)
//
//        self.$errorMessage
//            .map { $0 != nil }
//            .assign(to: \.isAlertPresented, on: self)
//            .store(in: &cancellables)

        self.store.$errorMessage
             .sink { [weak self] message in
                 self?.errorMessage = message
                 self?.isAlertPresented = message != nil
             }
             .store(in: &cancellables)

        // 空文字ではないかつ、0.5秒変化がなければ検索を実行する
        // TODO: 2回流れてくる
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
