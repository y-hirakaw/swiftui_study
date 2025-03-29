import Foundation

enum DomainError: Error, LocalizedError {
    case invalidCredentials
    case sessionExpired
    case postFailed
    case weatherUnavailable

    var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            return "無効な資格情報です。"
        case .sessionExpired:
            return "セッションが期限切れです。"
        case .postFailed:
            return "ポストに失敗しました。"
        case .weatherUnavailable:
            return "天気情報を取得できませんでした。"
        }
    }
}