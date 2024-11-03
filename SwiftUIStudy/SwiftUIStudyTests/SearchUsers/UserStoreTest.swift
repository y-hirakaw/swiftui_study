import Testing
import Dependencies

@testable import SwiftUIStudy

struct MockSearchUsersRepository: SearchUsersRepositoryProtocol {
    var mockSearchUsers: SearchUsers

    func fetchGitHubUsers(_ searchText: String) async throws -> SearchUsers {
        if searchText == "test" {
            return self.mockSearchUsers
        } else {
            // TODO: エラーハンドリングするならエラー投げても良さそう
            return SearchUsers(totalCount: 0, items: [])
        }
    }
}

@MainActor
struct UserStoreTest {

    @Test func searchUsersによってusersに値が格納されること() async throws {
        let mockSearchUsers = SearchUsers(
            totalCount: 2,
            items: [
                SearchUsers.User(userName: "testName1", avatarUrl: "https://avatar_url1"),
                SearchUsers.User(userName: "testName2", avatarUrl: "https://avatar_url2")
            ]
        )
        let store = withDependencies {
            $0.searchUsersRepository = MockSearchUsersRepository(mockSearchUsers: mockSearchUsers)
        } operation: {
            UserStore()
        }

        await store.searchUsers(query: "test")

        #expect(store.users?.totalCount == 2)
        #expect(store.users?.items[0].userName == "testName1")
        #expect(store.users?.items[1].avatarUrl == "https://avatar_url2")
    }

}
