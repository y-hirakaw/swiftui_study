import Foundation

struct GitHubAPI {

    // TODO: 引数省略する
    static func searchUsersURL(query: String) -> URL {
        return URL(string: "https://api.github.com/search/users?q=\(query)")!
    }

    static func userDetailURL(userName: String) -> URL {
        return URL(string: "https://api.github.com/users/\(userName)")!
    }

    static func userRepoURL(userName: String) -> URL {
        // NOTE: デフォルトでforkは含めない
        return URL(
            string: "https://api.github.com/users/\(userName)/repos?type=owner")!
    }

    static func repoLanguagesURL(_ userName: String, _ repositoryName: String)
        -> URL
    {
        return URL(
            string:
                "https://api.github.com/repos/\(userName)/\(repositoryName)/languages"
        )!
    }

    static func defaultHeaders() -> [String: String] {
        return [
            "Authorization": "token \(Const.gitHubPersonalAccessToken)",
            "Accept": "application/vnd.github.v3+json",
            "X-GitHub-Api-Version": "2022-11-28",
        ]
    }
}
