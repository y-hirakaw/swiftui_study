import Dependencies
import Testing

@testable import SwiftUIStudy

struct MockSearchUsersRepository: SearchUsersRepositoryProtocol {
    var mockSearchUsers: SearchUsers

    func fetchGitHubUsers(_ searchText: String) async throws(NetworkError)
        -> SearchUsers
    {
        if searchText == "test" {
            return self.mockSearchUsers
        } else {
            throw .invalidResponse
        }
    }
}

@MainActor
struct UserStoreTest {
    let store: UserStore

    init() async throws {
        let mockSearchUsers = SearchUsers.createMock()
        self.store = withDependencies {
            $0.searchUsersRepository = MockSearchUsersRepository(
                mockSearchUsers: mockSearchUsers)
        } operation: {
            UserStore()
        }
    }

    @Test func searchUsersによってusersに値が格納されること() async throws {
        await store.searchUsers(query: "test")

        #expect(store.users?.totalCount == 2)
        #expect(store.users?.items[0].userName == "testName1")
        #expect(store.users?.items[1].avatarUrl == "https://avatar_url2")
        #expect(store.errorMessage == nil)
    }

    @Test func searchUsersがエラーになった場合errorMessageが更新されること() async throws {
        await store.searchUsers(query: "error")

        #expect(store.users == nil)
        #expect(store.errorMessage == "無効なレスポンスを受信しました")
    }

}
