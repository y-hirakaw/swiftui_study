import Foundation
import Observation

@MainActor
protocol PostStoreProtocol: AnyObject {
    var postResponse: PostResponse? { get }
    func post() async throws
}

@Observable
@MainActor
class PostStore: PostStoreProtocol {
    static let shared = PostStore()

    private(set) var postResponse: PostResponse?

    private let repository: PostRepositoryProtocol

    init(repository: PostRepositoryProtocol = PostRepository()) {
        self.repository = repository
    }

    func post() async throws {
        self.postResponse = try await repository.post()
    }
}
