@testable import SwiftUIStudy

extension SearchUsers {

    static func createMock() -> SearchUsers {
        return SearchUsers(
            totalCount: 2,
            items: [
                SearchUsers.User(
                    id: 1, userName: "testName1",
                    avatarUrl: "https://avatar_url1"),
                SearchUsers.User(
                    id: 2, userName: "testName2",
                    avatarUrl: "https://avatar_url2"),
            ]
        )
    }
}
