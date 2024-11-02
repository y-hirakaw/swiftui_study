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
                    // TODO: アイコンを表示する必要がある
                    ForEach(searchUsers.items, id: \.userName) { item in
                        Text(item.userName)
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
