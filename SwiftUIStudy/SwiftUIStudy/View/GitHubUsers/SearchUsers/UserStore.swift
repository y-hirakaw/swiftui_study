import SwiftUI
import Combine
import Dependencies

@MainActor
final class UserStore: ObservableObject {
    static let shared: UserStore = .init()

    @Dependency(\.searchUsersRepository) private var searchUsersRepository

    @Published var users: SearchUsers?
    @Published var selectedUser: SearchUsers.User?

    func searchUsers(query: String) async {
        do {
            self.users = try await self.searchUsersRepository.fetchGitHubUsers(query)
        } catch {
            // TODO: エラーハンドリング
            print("\(#function) - \(error)")
        }
    }

    func selectUser(index: Int) {
        guard let users else { return }
        self.selectedUser = users.items[index]
    }
}

struct User: Identifiable {
    let id: Int
    let name: String
}
