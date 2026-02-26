import Dependencies
import Observation

@Observable
@MainActor
final class UserRepoStore {
    static let shared: UserRepoStore = .init()

    @ObservationIgnored
    @Dependency(\.userRepoRepository) private var userRepoRepository

    var repositories: [Repositories.Repository]?

    func loadUserRepositories(_ userName: String) async {
        do {
            self.repositories = try await self.userRepoRepository
                .requestGitHubUserRepositories(userName)
        } catch {
            // TODO: エラーハンドリング
            print("\(#function) - \(error)")
        }
    }

}
