import Combine
import Dependencies

@MainActor
final class UserRepoStore: ObservableObject {
    static let shared: UserRepoStore = .init()

    @Dependency(\.userRepoRepository) private var userRepoRepository

    @Published var repositories: [Repositories.Repository]?

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
