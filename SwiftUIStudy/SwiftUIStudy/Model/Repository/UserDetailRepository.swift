import Foundation
import Dependencies

protocol UserDetailRepositoryProtocol: Sendable {
    func requestGitHubUserDetail(_ userName: String) async throws -> UserDetail
}

struct UserDetailRepository: UserDetailRepositoryProtocol {

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

private enum UserDetailRepositoryKey: DependencyKey {
    static let liveValue: any UserDetailRepositoryProtocol = UserDetailRepository()
}

extension DependencyValues {
    var userDetailRepository: any UserDetailRepositoryProtocol {
        get { self[UserDetailRepositoryKey.self] }
        set { self[UserDetailRepositoryKey.self] = newValue }
    }
}
