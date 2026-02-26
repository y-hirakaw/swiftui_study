import Testing
import ViewInspector

@testable import SwiftUIStudy

@MainActor
final class MockSearchUsersViewState: SearchUsersViewState {
    private(set) var isCalledSearch: Bool = false

    override func search() async {
        self.isCalledSearch = true
    }
}

@MainActor
struct SearchUsersViewTest {
    let view: SearchUsersView
    let mockState: MockSearchUsersViewState

    init() {
        self.mockState = MockSearchUsersViewState()
        self.view = SearchUsersView(state: self.mockState)
    }

    @Test func 検索文字列が変わった時stateのseachが呼ばれる() async throws {
        self.mockState.searchText = "test"
        // デバウンス(0.5秒)待ち
        try? await Task.sleep(nanoseconds: 600_000_000)
        #expect(self.mockState.isCalledSearch == true)
    }
}
