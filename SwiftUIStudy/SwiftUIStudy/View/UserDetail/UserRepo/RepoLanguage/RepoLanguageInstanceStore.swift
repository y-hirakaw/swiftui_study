import Combine
import Dependencies

@MainActor
final class RepoLanguageInstanceStore: ObservableObject {
    @Dependency(\.languageRepository) private var languageRepository

    @Published var languages: Languages?

    func loadRepoLanguages(_ userName: String, _ repositoryName: String) async {
        do {
            self.languages = try await self.languageRepository
                .requestGitHubRepositoryLanguages(userName, repositoryName)
        } catch {
            // TODO: エラーハンドリング
            print("\(#function) - \(error)")
        }
    }

}
