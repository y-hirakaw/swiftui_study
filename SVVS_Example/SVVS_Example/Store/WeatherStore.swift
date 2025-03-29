import Combine
import Foundation

protocol WeatherStoreProtocol: AnyObject {
    var weatherResponsePublisher: Published<WeatherResponse?>.Publisher { get }
    var errorPublisher: Published<Error?>.Publisher { get }
    func fetchWeather() async
}

class WeatherStore: WeatherStoreProtocol {
    static let shared = WeatherStore()

    @Published private(set) var weatherResponse: WeatherResponse?
    @Published private(set) var error: Error?

    var weatherResponsePublisher: Published<WeatherResponse?>.Publisher { $weatherResponse }
    var errorPublisher: Published<Error?>.Publisher { $error }

    private let repository: WeatherRepositoryProtocol

    private init(repository: WeatherRepositoryProtocol = WeatherRepository()) {
        self.repository = repository
    }

    func fetchWeather() async {
        self.error = nil
        do {
            self.weatherResponse = try await repository.fetchWeather()
        } catch {
            self.error = error
            self.weatherResponse = nil
        }
    }
}