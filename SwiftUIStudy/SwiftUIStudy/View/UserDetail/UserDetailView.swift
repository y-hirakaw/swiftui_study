import SwiftUI

struct UserDetailView: View {
    let user: SearchUsers.User

    var body: some View {
        NavigationView {
            VStack {
                UserInfoView(self.user)
                Divider()
                UserRepoView(self.user)
            }
        }
        .navigationTitle("User Details")
    }
}
