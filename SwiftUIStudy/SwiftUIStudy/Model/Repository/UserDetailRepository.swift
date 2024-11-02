import Foundation

class UserDetailRepository {
    
    private let networkService: NetworkService
    
    init(networkService: NetworkService = NetworkService()) {
        self.networkService = networkService
    }
    
    func requestGitHubUserDetail(_ userName: String) async throws -> UserDetail {
        let url = GitHubAPI.userDetailURL(userName: userName)
        let headers = GitHubAPI.defaultHeaders()
        return try await networkService.request(url: url, method: "GET", headers: headers)
    }
}
