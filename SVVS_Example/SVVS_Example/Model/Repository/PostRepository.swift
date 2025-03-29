import Foundation

struct PostResponse: Codable {
    let result: String
}

protocol PostRepositoryProtocol: Sendable {
    func post() async throws -> PostResponse
}

struct PostRepository: PostRepositoryProtocol {
    func post() async throws -> PostResponse {
        try await Task.sleep(nanoseconds: 1_000_000_000)  // Simulate 1-second delay
        if Bool.random() {
            throw [NetworkError.serverError, DomainError.postFailed]
                .randomElement()!
        }
        return PostResponse(result: "Success")
    }
}
