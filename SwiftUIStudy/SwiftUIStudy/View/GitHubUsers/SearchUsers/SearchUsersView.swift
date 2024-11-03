import SwiftUI

struct SearchUsersView: View {
    @StateObject private var state: SearchUsersViewState

    init() {
        self._state = .init(wrappedValue: .init())
    }

    var body: some View {
        NavigationView {
            if let searchUsers = state.users {
                List {
                    ForEach(searchUsers.items, id: \.userName) { item in
                        NavigationLink(
                            destination: UserDetailView(user: item)
                        ) {
                            UserRowView(
                                userName: item.userName,
                                avatarURL: item.avatarUrl
                            )
                        }
                    }
                }
            } else {
                Text("No users found.")
            }
        }
        .navigationBarTitle(Text("GitHub Users"))
        .searchable(
            text: self.$state.searchText,
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: Text("ユーザ名を入力")
        )
    }
}

#Preview {
    SearchUsersView()
}
