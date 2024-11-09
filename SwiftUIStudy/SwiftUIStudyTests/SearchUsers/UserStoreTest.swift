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

    struct Parameter {
        let query: String
        let totalCount: Int?
        let userName: String?
        let avatarUrl: String?
        let errorMessage: String?
        init(_ query: String, _ totalCount: Int?, _ userName: String?, _ avatarUrl: String?, _ errorMessage: String?) {
            self.query = query
            self.totalCount = totalCount
            self.userName = userName
            self.avatarUrl = avatarUrl
            self.errorMessage = errorMessage
        }
    }

    init() async throws {
        let mockSearchUsers = SearchUsers.createMock()
        self.store = withDependencies {
            $0.searchUsersRepository = MockSearchUsersRepository(
                mockSearchUsers: mockSearchUsers)
        } operation: {
            UserStore()
        }
    }

    @Test(
        arguments:
            [
                Parameter("test", 2, "testName1", "https://avatar_url2", nil),
                Parameter("error", nil, nil, nil, "無効なレスポンスを受信しました")
            ]
    ) func searchUsersで成功失敗時に値が正しいこと(
        _ param: Parameter
    ) async throws {
        await store.searchUsers(query: param.query)

        #expect(store.users?.totalCount == param.totalCount)
        #expect(store.users?.items[0].userName == param.userName)
        #expect(store.users?.items[1].avatarUrl == param.avatarUrl)
        #expect(store.errorMessage == param.errorMessage)
    }
}
