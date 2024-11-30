import Testing
import Combine

@testable import SVVS_Example

@MainActor
struct HomeViewStateTests {

    @Test("分岐テスト", arguments:
            [
                (user: nil, expected: "名前が取得できません"),
                (user: User(id: "12345", name: "太郎"), expected: "こんにちは 太郎さん")
            ]
    )
    func userGreetingのテスト(user: User?, expected: String) {
        let mockUserStore = MockUserStore()
        mockUserStore.user = user
        let state = HomeViewState(store: mockUserStore)
        #expect(state.userGreeting == expected)
    }
}
