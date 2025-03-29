import Foundation

protocol WeatherRepositoryProtocol: Sendable {
    func fetchWeather() async throws -> String
}

struct WeatherRepository: WeatherRepositoryProtocol {
    func fetchWeather() async throws -> String {
        try await Task.sleep(nanoseconds: 1_000_000_000) // Simulate 1-second delay
        if Bool.random() {
            throw [NetworkError.serverError, DomainError.weatherUnavailable].randomElement()!
        }
        return "晴れ"
    }
}