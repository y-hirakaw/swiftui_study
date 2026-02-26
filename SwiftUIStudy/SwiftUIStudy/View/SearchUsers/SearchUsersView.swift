import SwiftUI

struct SearchUsersView: View {
    @State private var state: SearchUsersViewState

    init(state: SearchUsersViewState = SearchUsersViewState()) {
        self._state = State(initialValue: state)
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
        .alert("Error", isPresented: self.$state.isAlertPresented) {
            // ダイアログアクション
        } message: {
            if let message = self.state.errorMessage {
                Text(message)
            }
        }
    }
}

#Preview {
    SearchUsersView()
}
