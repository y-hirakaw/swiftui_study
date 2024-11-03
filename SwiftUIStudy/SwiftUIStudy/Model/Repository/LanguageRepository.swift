import Foundation
import Dependencies

protocol LanguageRepositoryProtocol: Sendable {
    func requestGitHubRepositoryLanguages(_ userName: String, _ repositoryName: String) async throws -> Languages
}

struct LanguageRepository: LanguageRepositoryProtocol {

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

private enum LanguageRepositoryKey: DependencyKey {
    static let liveValue: any LanguageRepositoryProtocol = LanguageRepository()
}

extension DependencyValues {
    var languageRepository: any LanguageRepositoryProtocol {
        get { self[LanguageRepositoryKey.self] }
        set { self[LanguageRepositoryKey.self] = newValue }
    }
}
