import Foundation

struct WeatherResponse: Codable {
    let latitude: Double
    let longitude: Double
    let timezone: String
    let current_weather: CurrentWeather
    let daily: DailyWeather
}

struct CurrentWeather: Codable {
    let temperature: Double
    let windspeed: Double
    let weathercode: Int
    let time: String
}

struct DailyWeather: Codable {
    let time: [String]
    let temperature_2m_max: [Double]
    let temperature_2m_min: [Double]
}
