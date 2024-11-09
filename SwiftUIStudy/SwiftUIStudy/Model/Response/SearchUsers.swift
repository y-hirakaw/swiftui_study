import Foundation

struct SearchUsers: Decodable {
    let totalCount: Int
    // TODO: これだけitemsなのが気になる
    let items: [User]

    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case items = "items"
    }

    struct User: Decodable {
        let id: Int
        let userName: String
        let avatarUrl: String

        enum CodingKeys: String, CodingKey {
            case id
            case userName = "login"
            case avatarUrl = "avatar_url"
        }
    }

    var userCount: Int {
        return self.items.count
    }

    func getUser(_ index: Int) -> User? {
        guard index >= 0 && index < self.items.count else {
            return nil
        }
        return self.items[index]
    }

    static let none = SearchUsers(totalCount: 0, items: [])
}
