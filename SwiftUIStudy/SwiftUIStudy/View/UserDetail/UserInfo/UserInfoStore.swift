import Combine
import Dependencies

@MainActor
final class UserInfoStore: ObservableObject {
    static let shared: UserInfoStore = .init()

    @Dependency(\.userDetailRepository) private var userDetailRepository

    @Published var userInfo: UserDetail?

    func loadUserInfo(_ userName: String) async {
        do {
            self.userInfo = try await self.userDetailRepository.requestGitHubUserDetail(userName)
        } catch {
            // TODO: エラーハンドリング
            print("\(#function) - \(error)")
        }
    }
}
