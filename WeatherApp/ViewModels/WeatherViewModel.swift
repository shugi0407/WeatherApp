import Foundation
import Combine

class WeatherViewModel: ObservableObject {
    @Published var weather: WeatherResponse?
    @Published var isLoading = false
    @Published var isOffline = false
    @Published var errorMessage: String?
    @Published var useFahrenheit = false
    
    private let service = WeatherService()
    private let cache = CacheManager()
    
    func fetchWeather(lat: Double, lon: Double) {
        isLoading = true
        isOffline = false
        errorMessage = nil
        
        service.fetchWeather(latitude: lat, longitude: lon) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                switch result {
                case .success(let weather):
                    self?.weather = weather
                    self?.cache.save(weather)
                case .failure:
                    if let cached = self?.cache.load() {
                        self?.weather = cached
                        self?.isOffline = true
                    } else {
                        self?.errorMessage = "Network error and no cached data"
                    }
                }
            }
        }
    }
    
    func temperature(_ celsius: Double) -> String {
        if useFahrenheit {
            let f = (celsius * 9/5) + 32
            return String(format: "%.1f°F", f)
        } else {
            return String(format: "%.1f°C", celsius)
        }
    }
}
