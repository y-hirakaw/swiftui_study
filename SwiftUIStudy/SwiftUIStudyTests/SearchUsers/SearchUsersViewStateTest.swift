import Testing
import Combine

@testable import SwiftUIStudy

@MainActor
class MockUserStore: UserStore {
    @Published var isCalledSearchUsers: Bool = false

    override func searchUsers(query: String) async {
        self.isCalledSearchUsers = true
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
    let mockStore: MockUserStore

    init() {
        self.mockStore = MockUserStore()
        self.state = SearchUsersViewState(store: self.mockStore)
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

    @Test func searchTextが変わった時にsearch関数が呼び出されること() async {
        var cancellables = Set<AnyCancellable>()
        await confirmation() { confirmation in
            self.mockStore.$isCalledSearchUsers
                .filter { $0 == true }
                .sink { _ in
                    confirmation()
                }
                .store(in: &cancellables)
            self.state.searchText = "test"
            // 0.5秒待つ、もっといい方法は無いか
            try? await Task.sleep(nanoseconds: 500_000_000)
        }

    }

}
