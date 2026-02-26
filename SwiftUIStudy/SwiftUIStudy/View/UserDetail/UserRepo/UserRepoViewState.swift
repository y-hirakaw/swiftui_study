import Foundation
import Observation

@Observable
@MainActor
final class UserRepoViewState {
    private let store: UserRepoStore = .shared

    var repositories: [Repositories.Repository]? { store.repositories }

    func onAppear(_ user: SearchUsers.User) async {
        store.repositories = nil
        await self.store.loadUserRepositories(user.userName)
    }
}
