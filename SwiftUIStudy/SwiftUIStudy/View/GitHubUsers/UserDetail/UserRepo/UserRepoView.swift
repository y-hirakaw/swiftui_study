import SwiftUI

struct UserRepoView: View {
    @StateObject private var state: UserRepoViewState
    let user: SearchUsers.User

    init(_ user: SearchUsers.User) {
        self._state = .init(wrappedValue: .init())
        self.user = user
    }

    var body: some View {
        VStack {
            if let repositories = self.state.repositories {
                List {
                    ForEach(repositories, id: \.name) { item in
                        Button(action: {
                            if let url = URL(string: item.url) {
                                UIApplication.shared.open(url)
                            }
                        }) {
                            Text(item.name)
//                            RepoLanguageView(self.user.userName, item.name)
                        }
                    }
                }
            } else {
                VStack {
                    ProgressView("Loading...")
                }
            }
        }
        .task {
            Task {
                await self.state.onAppear(self.user)
            }
        }
    }
}
