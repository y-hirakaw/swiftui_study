import Dependencies
import Foundation

protocol UserRepoRepositoryProtocol: Sendable {
    func requestGitHubUserRepositories(_ userName: String) async throws
        -> [Repositories.Repository]
}

struct UserRepoRepository: UserRepoRepositoryProtocol {

    private let networkService: NetworkService

    init(networkService: NetworkService = NetworkService()) {
        self.networkService = networkService
    }

    func requestGitHubUserRepositories(_ userName: String) async throws
        -> [Repositories.Repository]
    {
        let url = GitHubAPI.userRepoURL(userName: userName)
        let headers = GitHubAPI.defaultHeaders()
        return try await networkService.request(
            url: url, method: "GET", headers: headers)
    }
}

private enum UserRepoRepositoryKey: DependencyKey {
    static let liveValue: any UserRepoRepositoryProtocol = UserRepoRepository()
}

extension DependencyValues {
    var userRepoRepository: any UserRepoRepositoryProtocol {
        get { self[UserRepoRepositoryKey.self] }
        set { self[UserRepoRepositoryKey.self] = newValue }
    }
}
