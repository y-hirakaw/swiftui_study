import Foundation
import Observation

@Observable
@MainActor
class HomeViewState {
    private let homeUseCase: any HomeUseCaseProtocol
    var alertState: AlertState
    var shouldLogout: Bool = false
    var weather: String?

    init(homeUseCase: any HomeUseCaseProtocol = HomeUseCase()) {
        self.homeUseCase = homeUseCase
        self.alertState = .init(error: nil)
    }

    var userGreeting: String {
        guard let user = homeUseCase.user else { return "名前が取得できません" }
        return "こんにちは \(user.name)さん"
    }

    func onLogoutTapped() async {
        await perform {
            try await self.homeUseCase.logout()
            if self.homeUseCase.logoutResponse?.result == "Success" {
                self.shouldLogout = true
            }
        }
    }

    func onPostTapped() async {
        await perform {
            try await self.homeUseCase.post()
            if self.homeUseCase.postResponse != nil {
                self.alertState = AlertState(info: .postSuccess)
            }
        }
    }

    func onWeatherTapped() async {
        await perform {
            try await self.homeUseCase.fetchWeather()
            self.weather = self.homeUseCase.weatherResponse?.weather
        }
    }

    func onAlertConfirmed(alertState: AlertState) {
        self.alertState = .init(error: nil)
    }

    private func perform(_ action: () async throws -> Void) async {
        do {
            try await action()
        } catch {
            self.alertState = .init(error: error)
        }
    }
}
