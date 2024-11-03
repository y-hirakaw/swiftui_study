import SwiftUI

struct UserInfoView: View {
    @StateObject private var state: UserInfoViewState
    let user: SearchUsers.User

    init(_ user: SearchUsers.User) {
        self._state = .init(wrappedValue: .init())
        self.user = user
    }

    var body: some View {
        VStack {
            if let userInfo = self.state.userInfo {
                // userInfoが存在する場合のレイアウト
                VStack(alignment: .leading, spacing: 16) {
                    AsyncImage(url: URL(string: userInfo.avatarUrl)) { image in
                        image.resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                    } placeholder: {
                        ProgressView()
                    }

                    Text("Username: \(userInfo.login)")
                        .font(.headline)

                    if let name = userInfo.name {
                        Text("Name: \(name)")
                    }

                    if let followers = userInfo.followers {
                        Text("Followers: \(followers)")
                    }

                    if let following = userInfo.following {
                        Text("Following: \(following)")
                    }
                }
                .padding()
            } else {
                // userInfoがnilのときの読み込み表示
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
