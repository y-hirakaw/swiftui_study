import Foundation
import Combine

@MainActor
final class UserRepoViewState: ObservableObject {
    private let store: UserRepoStore = .shared

    @Published private(set) var repositories: [Repositories.Repository]?

    private var cancellables = Set<AnyCancellable>()

    init() {
        self.store.$repositories
            .assign(to: \.repositories, on: self)
            .store(in: &cancellables)
    }

    func onAppear(_ user: SearchUsers.User) async {
        self.repositories = nil
        await self.store.loadUserRepositories(user.userName)
    }
}
