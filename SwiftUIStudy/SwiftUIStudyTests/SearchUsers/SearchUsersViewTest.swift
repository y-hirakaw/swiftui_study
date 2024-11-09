import Combine
import Testing
import ViewInspector

@testable import SwiftUIStudy

@MainActor
final class MockSearchUsersViewState: SearchUsersViewState {
    @Published private(set) var isCalledSearch: Bool = false

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
        var cancellables = Set<AnyCancellable>()
        await confirmation { confirmation in
            self.mockState.$isCalledSearch
                .filter { $0 == true }
                .sink { _ in
                    confirmation()
                }
                .store(in: &cancellables)
            self.mockState.searchText = "test"
            // 0.5秒待つ、もっといい方法は無いか
            try? await Task.sleep(nanoseconds: 500_000_000)
        }
    }
}
