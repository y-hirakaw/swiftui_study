import Combine
import Foundation

protocol UserStoreProtocol: AnyObject {
    var userPublisher: Published<User?>.Publisher { get }
    var errorPublisher: Published<Error?>.Publisher { get }
    var logoutResponsePublisher: Published<LogoutResponse?>.Publisher { get }
    func login(_ userId: String, _ password: String) async
    func logout() async throws
}

class UserStore: UserStoreProtocol {
    static let shared = UserStore()

    @Published private(set) var user: User?
    @Published private(set) var error: Error?
    @Published private(set) var logoutResponse: LogoutResponse?

    var userPublisher: Published<User?>.Publisher { $user }
    var errorPublisher: Published<Error?>.Publisher { $error }
    var logoutResponsePublisher: Published<LogoutResponse?>.Publisher { $logoutResponse }

    private let repository: LoginRepositoryProtocol

    private init(repository: LoginRepositoryProtocol = LoginRepository()) {
        self.repository = repository
    }

    func login(_ userId: String, _ password: String) async {
        self.error = nil
        do {
            self.user = try await repository.login(userId, password)
        } catch {
            self.user = nil
            self.error = error
        }
    }

    func logout() async {
        self.error = nil
        do {
            self.logoutResponse = try await repository.logout()
        } catch {
            self.logoutResponse = nil
            self.error = error
        }
    }
}
