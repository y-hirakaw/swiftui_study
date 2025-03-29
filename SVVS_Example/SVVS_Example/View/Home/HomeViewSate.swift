import Combine
import Foundation

@MainActor
class HomeViewState: ObservableObject {
    private let homeUseCase: any HomeUseCaseProtocol
    @Published var user: User?
    @Published var alertState: AlertState
    @Published var shouldLogout: Bool = false
    @Published var weather: String?

    private var cancellables = Set<AnyCancellable>()

    init(homeUseCase: any HomeUseCaseProtocol = HomeUseCase()) {
        self.homeUseCase = homeUseCase
        self.alertState = .init()
        self.setupUseCaseBindings()
    }

    func setupUseCaseBindings() {
        self.homeUseCase.userPublisher
            .assign(to: &$user)

        self.homeUseCase.logoutResponsePublisher
            .sink { [weak self] response in
                if response?.result == "Success" {
                    self?.shouldLogout = true
                }
            }
            .store(in: &cancellables)

        self.homeUseCase.postResponsePublisher
            .compactMap({ $0 })
            .sink { [weak self] _ in
                self?.alertState = AlertState(info: .postSuccess)
            }
            .store(in: &cancellables)

        self.homeUseCase.weatherResponsePublisher
            .sink { [weak self] response in
                self?.weather = response?.weather
            }
            .store(in: &cancellables)

        self.homeUseCase.errorPublisher
            .sink { [weak self] error in
                if let error = error {
                    self?.alertState = .init(error: error)
                }
            }
            .store(in: &cancellables)
    }

    var userGreeting: String {
        guard let user else { return "名前が取得できません" }
        return "こんにちは \(user.name)さん"
    }

    func onLogoutTapped() async {
        await self.homeUseCase.logout()
    }

    func onPostTapped() async {
        await self.homeUseCase.post()
    }

    func onWeatherTapped() async {
        await self.homeUseCase.fetchWeather()
    }

    func onAlertConfirmed(alertState: AlertState) {
        self.alertState = .init()
    }
}
