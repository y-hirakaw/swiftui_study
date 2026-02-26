import Foundation
import Observation

@MainActor
protocol WeatherStoreProtocol: AnyObject {
    var weatherResponse: WeatherResponse? { get }
    func fetchWeather() async throws
}

@Observable
@MainActor
class WeatherStore: WeatherStoreProtocol {
    static let shared = WeatherStore()

    private(set) var weatherResponse: WeatherResponse?

    private let repository: WeatherRepositoryProtocol

    init(repository: WeatherRepositoryProtocol = WeatherRepository()) {
        self.repository = repository
    }

    func fetchWeather() async throws {
        self.weatherResponse = try await repository.fetchWeather()
    }
}
