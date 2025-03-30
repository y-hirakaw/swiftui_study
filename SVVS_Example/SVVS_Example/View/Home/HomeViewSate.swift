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
        self.alertState = .init(error: nil)
        self.setupUseCaseBindings()
    }

    func setupUseCaseBindings() {
        self.bind(
            self.homeUseCase.userPublisher, to: \.user, storeIn: &cancellables)

        self.bind(
            self.homeUseCase.logoutResponsePublisher, storeIn: &cancellables
        ) { [weak self] response in
            if response?.result == "Success" {
                self?.shouldLogout = true
            }
        }

        self.bindSkippingNil(
            self.homeUseCase.postResponsePublisher, storeIn: &cancellables
        ) { [weak self] _ in
            self?.alertState = AlertState(info: .postSuccess)
        }

        self.bind(
            self.homeUseCase.weatherResponsePublisher, storeIn: &cancellables
        ) { [weak self] response in
            self?.weather = response?.weather
        }

        self.bind(
            self.homeUseCase.errorPublisher, storeIn: &cancellables
        ) { [weak self] error in
            self?.alertState = .init(error: error)
        }
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
        self.alertState = .init(error: nil)
    }
}
