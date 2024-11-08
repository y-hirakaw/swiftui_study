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
                        VStack {
                            HStack {
                                Text(item.name)
                                Spacer()
                            }
                            HStack {
                                RepoLanguageView(self.user.userName, item.name)
                                Spacer()
                            }
                        }
                        .contentShape(Rectangle()) // タップ可能な領域を拡張
                        .onTapGesture {
                            if let url = URL(string: item.url) {
                                UIApplication.shared.open(url)
                            }
                        }
                    }
                }
                .listStyle(.grouped)
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
