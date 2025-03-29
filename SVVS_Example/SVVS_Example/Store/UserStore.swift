import Combine
import Foundation

@MainActor
protocol UserStoreProtocol: AnyObject {
    var userPublisher: Published<User?>.Publisher { get }
    var errorPublisher: Published<Error?>.Publisher { get }
    var logoutResponsePublisher: Published<LogoutResponse?>.Publisher { get }
    func login(_ userId: String, _ password: String) async
    func logout() async
}

@MainActor
class UserStore: ObservableObject, UserStoreProtocol {
    static let shared = UserStore()

    @Published private(set) var user: User?
    @Published private(set) var error: Error?
    @Published private(set) var logoutResponse: LogoutResponse?

    private let repository: LoginRepositoryProtocol

    private init(repository: LoginRepositoryProtocol = LoginRepository()) {
        self.repository = repository
    }

    var userPublisher: Published<User?>.Publisher {
        $user
    }

    var errorPublisher: Published<Error?>.Publisher {
        $error
    }

    var logoutResponsePublisher: Published<LogoutResponse?>.Publisher {
        $logoutResponse
    }

    func login(_ userId: String, _ password: String) async {
        self.error = nil
        do {
            self.user = try await repository.login(userId, password)
        } catch {
            self.error = error
        }
    }

    func logout() async {
        self.error = nil
        do {
            self.logoutResponse = try await repository.logout()
        } catch {
            self.error = error
            self.logoutResponse = nil
        }
    }
}
