import Combine

@MainActor
protocol UserStoreProtocol: ObservableObject {
    var userPublisher: Published<User?>.Publisher { get }
    var errorPublisher: Published<Error?>.Publisher { get }
    func login(_ userId: String, _ password: String) async
}

@MainActor
class UserStore: ObservableObject, UserStoreProtocol {
    static var shared = UserStore()

    let loginRepository: LoginRepositoryProtocol

    @Published var user: User?
    @Published var error: Error?
    // プロトコルに準拠するためのPublisher
    var userPublisher: Published<User?>.Publisher { $user }
    var errorPublisher: Published<Error?>.Publisher { $error }

    init(loginRepository: LoginRepositoryProtocol = LoginRepository()) {
        self.loginRepository = loginRepository
    }

    func login(_ userId: String, _ password: String) async {
        self.error = nil
        do {
            self.user = try await self.loginRepository.login(userId, password)
        } catch {
            await MainActor.run {
                self.user = nil
                self.error = error
            }
        }
    }
}
