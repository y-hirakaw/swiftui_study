import Dependencies
import Observation

@Observable
@MainActor
final class UserInfoStore {
    static let shared: UserInfoStore = .init()

    @ObservationIgnored
    @Dependency(\.userDetailRepository) private var userDetailRepository

    var userInfo: UserDetail?

    func loadUserInfo(_ userName: String) async {
        do {
            self.userInfo = try await self.userDetailRepository
                .requestGitHubUserDetail(userName)
        } catch {
            // TODO: エラーハンドリング
            print("\(#function) - \(error)")
        }
    }
}
