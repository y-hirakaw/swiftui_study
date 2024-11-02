import Combine

@MainActor
final class SearchUsersViewState: ObservableObject {
    private let store: UserStore = .shared

    @Published private(set) var users: SearchUsers?

    private var cancellables = Set<AnyCancellable>()

    @Published var searchText: String = ""

    init() {
        self.store.$users
            .assign(to: \.users, on: self)
            .store(in: &cancellables)
    }

    func search() async {
        await self.store.searchUsers(query: self.searchText)
    }
}
