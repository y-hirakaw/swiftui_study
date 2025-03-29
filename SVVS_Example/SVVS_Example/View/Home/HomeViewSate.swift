import Combine
import Foundation
import SwiftUI

struct AlertState: Identifiable {
    let id = UUID()
    var title = "メッセージ"
    var message: String
    @State var isPresented: Bool = false
    let error: Error?
    let info: InfoType?

    enum InfoType {
        case postSuccess

        var message: String {
            switch self {
            case .postSuccess:
                return "投稿が完了しました!"
            }
        }
    }

    init() {
        self.isPresented = false
        self.error = nil
        self.info = nil
        self.message = ""
    }

    init(error: Error) {
        self.error = error
        self.message = "エラーが発生しました: \(error.localizedDescription)"
        self.isPresented = true
        self.info = nil
    }

    init(info: InfoType) {
        self.info = info
        self.message = info.message
        self.isPresented = true
        self.error = nil
    }
}

@MainActor
class HomeViewState: ObservableObject {
    private let userStore: any UserStoreProtocol
    private let postStore: any PostStoreProtocol
    private let weatherStore: any WeatherStoreProtocol
    @Published var user: User?
    @Published var alertState: AlertState
    @Published var shouldLogout: Bool = false
    @Published var weather: String?

    private var cancellables = Set<AnyCancellable>()

    init(
        userStore: any UserStoreProtocol = UserStore.shared,
        postStore: any PostStoreProtocol = PostStore.shared,
        weatherStore: any WeatherStoreProtocol = WeatherStore.shared
    ) {
        self.userStore = userStore
        self.postStore = postStore
        self.weatherStore = weatherStore
        self.alertState = .init()
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
                }
            }
            .store(in: &cancellables)

        self.userStore.errorPublisher
            .sink { [weak self] error in
                if let error = error {
                    self?.alertState = .init(error: error)
                }
            }
            .store(in: &cancellables)
    }

    private func bindPostStore() {
        self.postStore.postResponsePublisher
            .compactMap({$0})
            .sink { [weak self] _ in
                self?.alertState = AlertState(info: .postSuccess)
            }
            .store(in: &cancellables)

        self.postStore.errorPublisher
            .sink { [weak self] error in
                if let error = error {
                    self?.alertState = .init(error: error)
                }
            }
            .store(in: &cancellables)
    }

    private func bindWeatherStore() {
        self.weatherStore.weatherResponsePublisher
            .sink { [weak self] response in
                self?.weather = response?.weather
            }
            .store(in: &cancellables)

        self.weatherStore.errorPublisher
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
        await self.userStore.logout()
    }

    func onPostTapped() async {
        await self.postStore.post()
    }

    func onWeatherTapped() async {
        await self.weatherStore.fetchWeather()
    }

    func onAlertConfirmed(alertState: AlertState) {
        self.alertState = .init()
    }
}
