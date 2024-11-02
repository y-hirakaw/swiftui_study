import Foundation

class UserRepoRepository {
    
    private let networkService: NetworkService
    
    init(networkService: NetworkService = NetworkService()) {
        self.networkService = networkService
    }
    
    func requestGitHubUserRepositories(_ userName: String) async throws -> [Repositories.Repository] {
        let url = GitHubAPI.userRepoURL(userName: userName)
        let headers = GitHubAPI.defaultHeaders()
        return try await networkService.request(url: url, method: "GET", headers: headers)
    }
}
