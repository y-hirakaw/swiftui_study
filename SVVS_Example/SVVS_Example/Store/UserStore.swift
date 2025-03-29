import Combine
import Foundation

protocol UserStoreProtocol: AnyObject {
    var userPublisher: AnyPublisher<User?, Never> { get }
    var errorPublisher: AnyPublisher<Error?, Never> { get }
    var logoutResponsePublisher: AnyPublisher<LogoutResponse?, Never> { get }
    func login(_ userId: String, _ password: String) async
    func logout() async
}

actor UserStore: UserStoreProtocol {
    static let shared = UserStore()

    @Published private(set) var user: User?
    @Published private(set) var error: Error?
    @Published private(set) var logoutResponse: LogoutResponse?

    private let repository: LoginRepositoryProtocol

    private init(repository: LoginRepositoryProtocol = LoginRepository()) {
        self.repository = repository
    }

    var userPublisher: AnyPublisher<User?, Never> {
        $user.eraseToAnyPublisher()
    }

    var errorPublisher: AnyPublisher<Error?, Never> {
        $error.eraseToAnyPublisher()
    }

    var logoutResponsePublisher: AnyPublisher<LogoutResponse?, Never> {
        $logoutResponse.eraseToAnyPublisher()
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
