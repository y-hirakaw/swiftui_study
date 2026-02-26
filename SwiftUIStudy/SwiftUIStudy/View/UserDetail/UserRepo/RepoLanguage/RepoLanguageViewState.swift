import Foundation
import Observation

@Observable
@MainActor
final class RepoLanguageViewState {
    // Viewごとに言語情報を持ちたいためsharedにはしない
    private let store: RepoLanguageLocalStore

    var languages: Languages? { store.languages }

    init(store: RepoLanguageLocalStore = RepoLanguageLocalStore()) {
        self.store = store
    }

    func onAppear(_ userName: String, _ repositoryName: String) async {
        store.languages = nil
        await self.store.loadRepoLanguages(userName, repositoryName)
    }
}
