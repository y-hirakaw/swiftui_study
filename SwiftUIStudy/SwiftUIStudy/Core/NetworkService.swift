import Foundation

/// 汎用的な通信を行うサービスクラス
class NetworkService {
    
    // TODO: 今回GETしかしないのでmethod隠蔽しても良さそう
    /// リクエスト
    func request<T>(url: URL, method: String, headers: [String: String]) async throws -> T where T: Decodable {
        var request = URLRequest(url: url)
        request.httpMethod = method
        headers.forEach {
            request.addValue($0.value, forHTTPHeaderField: $0.key)
        }
        let (data, _) = try await URLSession.shared.data(for: request)
        let response = try JSONDecoder().decode(T.self, from: data)
        return response
    }
}
