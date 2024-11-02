struct UserDetail: Decodable {
    let login: String
    let avatarUrl: String
    var name: String?
    var followers: Int?
    var following: Int?

    enum CodingKeys: String, CodingKey {
        case login = "login"
        case name = "name"
        case avatarUrl = "avatar_url"
        case followers = "followers"
        case following = "following"
    }
}
