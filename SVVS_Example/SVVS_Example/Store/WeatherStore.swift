import Combine
import Foundation

protocol WeatherStoreProtocol: AnyObject {
    func fetchWeather() async throws -> String
}

class WeatherStore: WeatherStoreProtocol {
    static let shared = WeatherStore()

    private let repository: WeatherRepositoryProtocol

    private init(repository: WeatherRepositoryProtocol = WeatherRepository()) {
        self.repository = repository
    }

    func fetchWeather() async throws -> String {
        return try await repository.fetchWeather()
    }
}