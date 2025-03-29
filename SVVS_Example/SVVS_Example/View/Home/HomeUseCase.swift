import Combine
import Foundation

@MainActor
protocol HomeUseCaseProtocol {
    var userPublisher: Published<User?>.Publisher { get }
    var logoutResponsePublisher: Published<LogoutResponse?>.Publisher { get }
    var postResponsePublisher: Published<PostResponse?>.Publisher { get }
    var weatherResponsePublisher: Published<WeatherResponse?>.Publisher { get }
    var errorPublisher: Published<Error?>.Publisher { get }

    func logout() async
    func post() async
    func fetchWeather() async
}

@MainActor
class HomeUseCase: HomeUseCaseProtocol {
    @Published private var user: User?
    @Published private var logoutResponse: LogoutResponse?
    @Published private var postResponse: PostResponse?
    @Published private var weatherResponse: WeatherResponse?
    @Published private var error: Error?

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

        self.setupBindings()
    }

    var userPublisher: Published<User?>.Publisher { $user }
    var logoutResponsePublisher: Published<LogoutResponse?>.Publisher { $logoutResponse }
    var postResponsePublisher: Published<PostResponse?>.Publisher { $postResponse }
    var weatherResponsePublisher: Published<WeatherResponse?>.Publisher { $weatherResponse }
    var errorPublisher: Published<Error?>.Publisher { $error }

    private func setupBindings() {
        self.userStore.userPublisher
            .assign(to: &$user)

        self.userStore.logoutResponsePublisher
            .assign(to: &$logoutResponse)

        self.postStore.postResponsePublisher
            .assign(to: &$postResponse)

        self.weatherStore.weatherResponsePublisher
            .assign(to: &$weatherResponse)

        Publishers.Merge3(
            self.userStore.errorPublisher,
            self.postStore.errorPublisher,
            self.weatherStore.errorPublisher
        )
        .assign(to: &$error)
    }

    func logout() async {
        await userStore.logout()
    }

    func post() async {
        await postStore.post()
    }

    func fetchWeather() async {
        await weatherStore.fetchWeather()
    }
}
