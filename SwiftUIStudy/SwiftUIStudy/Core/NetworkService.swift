import Foundation

/// 汎用的な通信を行うサービスクラス
final class NetworkService: Sendable {

    // TODO: 今回GETしかしないのでmethod隠蔽しても良さそう
    /// リクエスト
    func request<T>(url: URL, method: String, headers: [String: String]) async throws -> T where T: Decodable {
        var request = URLRequest(url: url)
        request.httpMethod = method
        headers.forEach {
            request.addValue($0.value, forHTTPHeaderField: $0.key)
        }
        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }
            try self.validateHttpResponse(httpResponse)
            do {
                return try JSONDecoder().decode(T.self, from: data)
            } catch {
                throw NetworkError.decodingError(error)
            }
        } catch let error as NetworkError {
            throw error
        } catch {
            throw NetworkError.networkError(error)
        }
    }

    /// HTTPレスポンスの検証
    /// - Parameter response: HTTPレスポンス
    private func validateHttpResponse(_ response: HTTPURLResponse) throws {
        switch response.statusCode {
        case 200...299:
            return
        default:
            throw NetworkError.httpError(statusCode: response.statusCode)
        }
    }
}
