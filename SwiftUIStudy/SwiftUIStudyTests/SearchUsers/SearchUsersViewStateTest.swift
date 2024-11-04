import Testing
import Dependencies

@testable import SwiftUIStudy

@MainActor
class MockUserStore: UserStore {
    private(set) var setQuery: String?

    override func searchUsers(query: String) async {
        self.setQuery = query
        if query == "test" {
            self.users = SearchUsers.createMock()
        } else {
            await MainActor.run {
                self.users = nil
                self.errorMessage = NetworkError.invalidResponse.errorDescription
            }
        }
    }
}

@MainActor
struct SearchUsersViewStateTest {
    let state: SearchUsersViewState

    init() {
        self.state = SearchUsersViewState(store: MockUserStore())
    }

    @Test func search関数を呼び出し成功したらusersに値が格納されること() async {
        self.state.searchText = "test"
        await self.state.search()

        #expect(state.users?.totalCount == 2)
        #expect(state.users?.items[0].userName == "testName1")
        #expect(state.users?.items[1].avatarUrl == "https://avatar_url2")
        #expect(state.errorMessage == nil)
    }

    @Test func search関数を呼び出し失敗したらusersに値が格納されること() async {
        self.state.searchText = "invalid"
        await self.state.search()

        #expect(state.users == nil)
        #expect(state.errorMessage == "無効なレスポンスを受信しました")
    }

}
