import Foundation

class LanguageRepository {
    
    private let networkService: NetworkService
    
    init(networkService: NetworkService = NetworkService()) {
        self.networkService = networkService
    }
    
    func requestGitHubRepositoryLanguages(_ userName: String, _ repositoryName: String) async throws -> Languages {
        let url = GitHubAPI.repoLanguagesURL(userName, repositoryName)
        let headers = GitHubAPI.defaultHeaders()
        return try await networkService.request(url: url, method: "GET", headers: headers)
    }
}
