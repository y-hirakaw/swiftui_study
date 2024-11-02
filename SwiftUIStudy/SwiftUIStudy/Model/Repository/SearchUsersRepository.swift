import Foundation
import Dependencies

protocol SearchUsersRepositoryProtocol: Sendable {
    func fetchGitHubUsers(_ searchText: String) async throws -> SearchUsers
}

struct SearchUsersRepository: SearchUsersRepositoryProtocol {

    private let networkService: NetworkService
    
    init(networkService: NetworkService = NetworkService()) {
        self.networkService = networkService
    }

    // TODO: 連続呼び出しの制御はしていない
    func fetchGitHubUsers(_ searchText: String) async throws -> SearchUsers {
        do {
            return try await self.requestGitHubSearchUsers(searchText)
        } catch {
            // エラーハンドリング
            if error is URLError && (error as? URLError)?.code == .cancelled {
                print("Search was cancelled")
            } else {
                print("Error: \(error)")
            }
            throw error
        }
    }
    
    func requestGitHubSearchUsers(_ searchText: String) async throws -> SearchUsers {
        let query = "\(searchText)"
        let url = GitHubAPI.searchUsersURL(query: query)
        let headers = GitHubAPI.defaultHeaders()
        return try await networkService.request(url: url, method: "GET", headers: headers)
    }
}

private enum SearchUsersRepositoryKey: DependencyKey {
    static let liveValue: any SearchUsersRepositoryProtocol = SearchUsersRepository()
}

extension DependencyValues {
    var searchUsersRepository: any SearchUsersRepositoryProtocol {
        get { self[SearchUsersRepositoryKey.self] }
        set { self[SearchUsersRepositoryKey.self] = newValue }
    }
}
