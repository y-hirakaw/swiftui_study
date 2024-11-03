import Combine
import Dependencies

@MainActor
final class UserStore: ObservableObject {
    static let shared: UserStore = .init()

    @Dependency(\.searchUsersRepository) private var searchUsersRepository

    @Published var users: SearchUsers?

    func searchUsers(query: String) async {
        do {
            self.users = try await self.searchUsersRepository.fetchGitHubUsers(query)
        } catch {
            // TODO: エラーハンドリング
            print("\(#function) - \(error)")
        }
    }
}

struct User: Identifiable {
    let id: Int
    let name: String
}
