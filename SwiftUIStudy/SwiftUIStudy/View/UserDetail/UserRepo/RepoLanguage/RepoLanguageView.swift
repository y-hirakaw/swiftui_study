import SwiftUI

struct RepoLanguageView: View {
    @StateObject private var state: RepoLanguageViewState
    let userName: String
    let repositoryName: String

    init(_ userName: String, _ repositoryName: String) {
        self._state = .init(wrappedValue: .init())
        self.userName = userName
        self.repositoryName = repositoryName
    }

    var body: some View {
        HStack {
            // TODO: この作りにしてしまうと、一つしか存在しないStoreのLanguagesが表示されるので、全てのitemが同じ値になってしまうデータの持ち方を変える必要ある
            if let languages = self.state.languages {
                ForEach(languages.languages, id: \.self) { item in
                    Text(item)
                }
            } else {
                VStack {
                    ProgressView("Loading...")
                }
            }
        }
        .task {
            Task {
                await self.state.onAppear(self.userName, self.repositoryName)
            }
        }
    }
}
