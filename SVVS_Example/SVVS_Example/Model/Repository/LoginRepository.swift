import Foundation

protocol LoginRepositoryProtocol: Sendable {
    func login(_ userId: String, _ password: String) async throws -> User
}

struct LoginRepository: LoginRepositoryProtocol {

    /// ログインを実施する
    /// - Parameters:
    ///   - userId: ユーザID
    ///   - password: パスワード
    /// - Returns: ログインしたユーザ情報
    func login(_ userId: String, _ password: String) async throws -> User {
        try await Task.sleep(nanoseconds: 1_000_000_000) // 1秒待つ
        return User(id: "12345", name: "太郎")
    }
}
