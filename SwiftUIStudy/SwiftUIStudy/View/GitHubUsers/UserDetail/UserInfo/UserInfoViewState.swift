import Foundation
import Combine

@MainActor
final class UserInfoViewState: ObservableObject {
    private let store: UserInfoStore = .shared

    @Published private(set) var userInfo: UserDetail?

    private var cancellables = Set<AnyCancellable>()

    init() {
        self.store.$userInfo
            .assign(to: \.userInfo, on: self)
            .store(in: &cancellables)
    }

    func onAppear(_ user: SearchUsers.User) async {
        self.userInfo = nil
        await self.store.loadUserInfo(user.userName)
    }
}
