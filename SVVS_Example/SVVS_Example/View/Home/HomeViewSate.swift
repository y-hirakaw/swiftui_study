import Combine
import Foundation

@MainActor
class HomeViewState: ObservableObject {
    private let userStore: any UserStoreProtocol
    private let postStore: any PostStoreProtocol
    private let weatherStore: any WeatherStoreProtocol
    @Published var user: User?
    @Published var alertMessage: String?
    @Published var shouldLogout: Bool = false

    private var cancellables = Set<AnyCancellable>()

    init(userStore: any UserStoreProtocol = UserStore.shared,
         postStore: any PostStoreProtocol = PostStore.shared,
         weatherStore: any WeatherStoreProtocol = WeatherStore.shared) {
        self.userStore = userStore
        self.postStore = postStore
        self.weatherStore = weatherStore
        self.setupStoreBindings()
    }

    func setupStoreBindings() {
        self.bindUserStore()
        self.bindPostStore()
        self.bindWeatherStore()
    }

    private func bindUserStore() {
        self.userStore.userPublisher
            .sink { [weak self] user in
                self?.user = user
            }
            .store(in: &cancellables)

        self.userStore.logoutResponsePublisher
            .sink { [weak self] response in
                if response?.result == "Success" {
                    self?.shouldLogout = true
                    self?.alertMessage = "ログアウトしました"
                }
            }
            .store(in: &cancellables)

        self.userStore.errorPublisher
            .sink { [weak self] error in
                if let error = error {
                    self?.alertMessage = "エラーが発生しました: \(error.localizedDescription)"
                }
            }
            .store(in: &cancellables)
    }

    private func bindPostStore() {
        self.postStore.postResponsePublisher
            .sink { [weak self] response in
                if let response = response {
                    self?.alertMessage = "ポストに成功しました: \(response.result)"
                }
            }
            .store(in: &cancellables)

        self.postStore.errorPublisher
            .sink { [weak self] error in
                if let error = error {
                    self?.alertMessage = "ポストに失敗しました: \(error.localizedDescription)"
                }
            }
            .store(in: &cancellables)
    }

    private func bindWeatherStore() {
        self.weatherStore.weatherResponsePublisher
            .sink { [weak self] response in
                if let weather = response?.weather {
                    self?.alertMessage = "天気情報: \(weather)"
                }
            }
            .store(in: &cancellables)

        self.weatherStore.errorPublisher
            .sink { [weak self] error in
                if let error = error {
                    self?.alertMessage = "天気情報の取得に失敗しました: \(error.localizedDescription)"
                }
            }
            .store(in: &cancellables)
    }

    var userGreeting: String {
        guard let user else { return "名前が取得できません" }
        return "こんにちは \(user.name)さん"
    }

    func onLogoutTapped() async {
        await self.userStore.logout()
    }

    func onPostTapped() async {
        await self.postStore.post()
    }

    func onWeatherTapped() async {
        await self.weatherStore.fetchWeather()
    }
}
