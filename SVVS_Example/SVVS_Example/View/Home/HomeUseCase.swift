import Foundation
import Observation

@MainActor
protocol HomeUseCaseProtocol: AnyObject {
    var user: User? { get }
    var logoutResponse: LogoutResponse? { get }
    var postResponse: PostResponse? { get }
    var weatherResponse: WeatherResponse? { get }

    func logout() async throws
    func post() async throws
    func fetchWeather() async throws
}

@Observable
@MainActor
class HomeUseCase: HomeUseCaseProtocol {
    private let userStore: any UserStoreProtocol
    private let postStore: any PostStoreProtocol
    private let weatherStore: any WeatherStoreProtocol

    init(
        userStore: any UserStoreProtocol = UserStore.shared,
        postStore: any PostStoreProtocol = PostStore.shared,
        weatherStore: any WeatherStoreProtocol = WeatherStore.shared
    ) {
        self.userStore = userStore
        self.postStore = postStore
        self.weatherStore = weatherStore
    }

    var user: User? { userStore.user }
    var logoutResponse: LogoutResponse? { userStore.logoutResponse }
    var postResponse: PostResponse? { postStore.postResponse }
    var weatherResponse: WeatherResponse? { weatherStore.weatherResponse }

    func logout() async throws {
        try await userStore.logout()
    }

    func post() async throws {
        try await postStore.post()
    }

    func fetchWeather() async throws {
        try await weatherStore.fetchWeather()
    }
}
