import Foundation
import Observation

@Observable
@MainActor
final class UserInfoViewState {
    private let store: UserInfoStore = .shared

    var userInfo: UserDetail? { store.userInfo }

    func onAppear(_ user: SearchUsers.User) async {
        store.userInfo = nil
        await self.store.loadUserInfo(user.userName)
    }
}
