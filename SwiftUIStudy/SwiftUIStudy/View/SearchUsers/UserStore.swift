import Combine
import Dependencies

@MainActor
final class UserStore: ObservableObject {
    static let shared: UserStore = .init()

    @Dependency(\.searchUsersRepository) private var searchUsersRepository

    @Published var users: SearchUsers?
    @Published var errorMessage: String?

    func searchUsers(query: String) async {
        self.errorMessage = nil
        do {
            self.users = try await self.searchUsersRepository.fetchGitHubUsers(query)
        } catch {
            self.users = nil
            self.errorMessage = error.errorDescription
        }
    }
}

struct User: Identifiable {
    let id: Int
    let name: String
}
