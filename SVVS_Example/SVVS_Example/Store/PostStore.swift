import Combine
import Foundation

@MainActor
protocol PostStoreProtocol: AnyObject {
    var postResponsePublisher: Published<PostResponse?>.Publisher { get }
    var errorPublisher: Published<Error?>.Publisher { get }
    func post() async
}

@MainActor
class PostStore: PostStoreProtocol {
    static let shared = PostStore()

    @Published private(set) var postResponse: PostResponse?
    @Published private(set) var error: Error?

    var postResponsePublisher: Published<PostResponse?>.Publisher { $postResponse }
    var errorPublisher: Published<Error?>.Publisher { $error }

    private let repository: PostRepositoryProtocol

    private init(repository: PostRepositoryProtocol = PostRepository()) {
        self.repository = repository
    }

    func post() async {
        self.error = nil
        do {
            self.postResponse = try await repository.post()
        } catch {
            self.error = error
            self.postResponse = nil
        }
    }
}
