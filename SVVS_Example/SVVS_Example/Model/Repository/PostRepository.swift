import Foundation

protocol PostRepositoryProtocol: Sendable {
    func post() async throws
}

struct PostRepository: PostRepositoryProtocol {
    func post() async throws {
        try await Task.sleep(nanoseconds: 1_000_000_000) // Simulate 1-second delay
        if Bool.random() {
            throw [NetworkError.serverError, DomainError.postFailed].randomElement()!
        }
    }
}