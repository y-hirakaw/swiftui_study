import Combine
import Foundation

@MainActor
final class RepoLanguageViewState: ObservableObject {
    // Viewごとに言語情報を持ちたいためsharedにはしない
    private let store: RepoLanguageLocalStore

    @Published private(set) var languages: Languages?

    private var cancellables = Set<AnyCancellable>()

    init(store: RepoLanguageLocalStore = RepoLanguageLocalStore()) {
        self.store = store
        self.store.$languages
            .assign(to: \.languages, on: self)
            .store(in: &cancellables)
    }

    func onAppear(_ userName: String, _ repositoryName: String) async {
        self.languages = nil
        await self.store.loadRepoLanguages(userName, repositoryName)
    }
}
