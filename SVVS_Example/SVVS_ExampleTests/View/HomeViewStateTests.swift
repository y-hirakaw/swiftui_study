import Testing
import Observation

@testable import SVVS_Example

@Observable
@MainActor
class MockHomeUseCase: HomeUseCaseProtocol {
    var user: User? = nil
    var logoutResponse: LogoutResponse? = nil
    var postResponse: PostResponse? = nil
    var weatherResponse: WeatherResponse? = nil

    var logoutError: Error?
    var postError: Error?
    var fetchWeatherError: Error?

    func logout() async throws {
        if let logoutError { throw logoutError }
    }
    func post() async throws {
        if let postError { throw postError }
    }
    func fetchWeather() async throws {
        if let fetchWeatherError { throw fetchWeatherError }
    }
}

@MainActor
struct HomeViewStateTests {

    @Test("分岐テスト", arguments:
            [
                (user: nil, expected: "名前が取得できません"),
                (user: User(id: "12345", name: "太郎"), expected: "こんにちは 太郎さん")
            ]
    )
    func userGreetingのテスト(user: User?, expected: String) {
        let mockUseCase = MockHomeUseCase()
        mockUseCase.user = user
        let state = HomeViewState(homeUseCase: mockUseCase)
        #expect(state.userGreeting == expected)
    }
}
