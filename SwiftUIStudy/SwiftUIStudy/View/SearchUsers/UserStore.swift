import Dependencies
import Observation

// protocol UserStoreProtocol: Sendable {
//    func searchUsers(query: String) async
// }

@Observable
@MainActor
class UserStore {
    static var shared: UserStore = .init()

    @ObservationIgnored
    @Dependency(\.searchUsersRepository) private var searchUsersRepository

    var users: SearchUsers?
    var errorMessage: String?

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
