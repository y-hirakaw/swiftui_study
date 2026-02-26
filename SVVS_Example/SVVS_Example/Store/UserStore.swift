import Foundation
import Observation

@MainActor
protocol UserStoreProtocol: AnyObject {
    var user: User? { get }
    var logoutResponse: LogoutResponse? { get }
    func login(_ userId: String, _ password: String) async throws
    func logout() async throws
}

@Observable
@MainActor
class UserStore: UserStoreProtocol {
    static let shared = UserStore()

    private(set) var user: User?
    private(set) var logoutResponse: LogoutResponse?

    private let repository: LoginRepositoryProtocol

    init(repository: LoginRepositoryProtocol = LoginRepository()) {
        self.repository = repository
    }

    func login(_ userId: String, _ password: String) async throws {
        self.user = try await repository.login(userId, password)
    }

    func logout() async throws {
        self.logoutResponse = try await repository.logout()
    }
}
