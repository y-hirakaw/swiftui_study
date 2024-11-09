import Combine
import Dependencies

// protocol UserStoreProtocol: Sendable {
//    func searchUsers(query: String) async
// }

@MainActor
class UserStore: ObservableObject {
    static var shared: UserStore = .init()

    @Dependency(\.searchUsersRepository) private var searchUsersRepository

    @Published var users: SearchUsers?
    @Published var errorMessage: String?

    func searchUsers(query: String) async {
        do {
            self.users = try await self.searchUsersRepository.fetchGitHubUsers(
                query)
        } catch {
            await MainActor.run {
                self.users = nil
                self.errorMessage = error.errorDescription
            }
        }
    }
}

// TODO: MainActor関連のエラーを解消できていない
// private enum UserStoreKey: DependencyKey {
//    static var liveValue: any UserStoreProtocol = UserStore.shared
// }
//
// extension DependencyValues {
//    var userStore: any UserStoreProtocol {
//        get { self[UserStoreKey.self] }
//        set { self[UserStoreKey.self] = newValue }
//    }
// }
