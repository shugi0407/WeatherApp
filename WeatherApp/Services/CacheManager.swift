import Foundation

class CacheManager {
    private let cacheKey = "cachedWeather"
    
    func save(_ weather: WeatherResponse) {
        if let encoded = try? JSONEncoder().encode(weather) {
            UserDefaults.standard.set(encoded, forKey: cacheKey)
        }
    }
    
    func load() -> WeatherResponse? {
        guard let data = UserDefaults.standard.data(forKey: cacheKey),
              let decoded = try? JSONDecoder().decode(WeatherResponse.self, from: data) else {
            return nil
        }
        return decoded
    }
}
