import Foundation

struct WeatherResponse: Codable {
    let weather: String
}

protocol WeatherRepositoryProtocol: Sendable {
    func fetchWeather() async throws -> WeatherResponse
}

struct WeatherRepository: WeatherRepositoryProtocol {
    func fetchWeather() async throws -> WeatherResponse {
        try await Task.sleep(nanoseconds: 1_000_000_000) // Simulate 1-second delay
        if Bool.random() {
            throw [NetworkError.serverError, DomainError.weatherUnavailable].randomElement()!
        }
        return WeatherResponse(weather: "晴れ")
    }
}