import Dependencies
import Observation

@Observable
@MainActor
final class RepoLanguageLocalStore {
    @ObservationIgnored
    @Dependency(\.languageRepository) private var languageRepository

    var languages: Languages?

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
