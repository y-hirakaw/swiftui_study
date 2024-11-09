import Foundation

class AvatarRepository {

    private let networkService: NetworkService

    init(networkService: NetworkService = NetworkService()) {
        self.networkService = networkService
    }

    // TODO: できるだけキャッシュを使う設定にした方が良いかも
    func fetchImageData(_ avatarUrl: String) async throws -> Data {
        guard let url = URL(string: avatarUrl) else {
            throw URLError(.badURL)
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return data
        } catch {
            throw error
        }
    }
}
