import Foundation
import Combine

@MainActor
final class RepoLanguageViewState: ObservableObject {
//    private let store: RepoLanguageStore = .shared
    // Viewごとに言語情報を持ちたいためsharedにはしない
    private let store: RepoLanguageStore

    @Published private(set) var languages: Languages?

    private var cancellables = Set<AnyCancellable>()

    init(store: RepoLanguageStore = RepoLanguageStore()) {
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
