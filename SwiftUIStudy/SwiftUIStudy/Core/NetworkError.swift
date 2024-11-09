import Foundation

enum NetworkError: LocalizedError {
    case invalidResponse
    case httpError(statusCode: Int)
    case decodingError(Error)
    case networkError(Error)

    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "無効なレスポンスを受信しました"
        case .httpError(let statusCode):
            return "サーバーエラーが発生しました (ステータスコード: \(statusCode))"
        case .decodingError(let error):
            return "データの解析に失敗しました: \(error.localizedDescription)"
        case .networkError(let error):
            return "通信エラーが発生しました: \(error.localizedDescription)"
        }
    }
}
