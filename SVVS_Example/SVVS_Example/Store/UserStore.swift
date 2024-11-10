import Combine

@MainActor
class UserStore: ObservableObject {
    static var shared: UserStore = .init()

    let loginRepository: LoginRepositoryProtocol

    @Published var user: User?
    @Published var error: Error?

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
