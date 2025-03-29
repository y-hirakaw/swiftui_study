import Combine
import Foundation

protocol PostStoreProtocol: AnyObject {
    func post() async throws
}

class PostStore: PostStoreProtocol {
    static let shared = PostStore()

    private let repository: PostRepositoryProtocol

    private init(repository: PostRepositoryProtocol = PostRepository()) {
        self.repository = repository
    }

    func post() async throws {
        try await repository.post()
    }
}