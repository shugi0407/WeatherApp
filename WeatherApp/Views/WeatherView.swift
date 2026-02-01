import SwiftUI

struct WeatherView: View {
    @StateObject private var vm = WeatherViewModel()
    @State private var city = "London"
    @State private var lat: Double = 51.5072
    @State private var lon: Double = -0.1276
    @State private var showingSettings = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                TextField("Enter city name (e.g., London)", text: $city)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                Button("Get Weather") {
                    // For simplicity: hardcoded city coords, or you can extend using Open-Meteo Geocoding API
                    getCoordinates(for: city)
                }
                .buttonStyle(.borderedProminent)
                
                if vm.isLoading {
                    ProgressView("Loading…")
                } else if let w = vm.weather {
                    VStack(spacing: 8) {
                        Text(city)
                            .font(.largeTitle)
                            .bold()
                        
                        Text("Current: \(vm.temperature(w.current_weather.temperature))")
                            .font(.title2)
                        Text("Wind: \(w.current_weather.windspeed, specifier: "%.1f") m/s")
                        
                        VStack {
                            Text("3‑Day Forecast:")
                                .font(.headline)
                            ForEach(0..<min(3, w.daily.time.count), id: \.self) { i in
                                Text("Day \(i+1): \(vm.temperature(w.daily.temperature_2m_min[i])) – \(vm.temperature(w.daily.temperature_2m_max[i]))")
                            }
                        }
                        
                        if vm.isOffline {
                            Text("Offline data shown")
                                .foregroundColor(.yellow)
                        }
                    }
                    .padding()
                } else if let error = vm.errorMessage {
                    Text("Error: \(error)")
                        .foregroundColor(.red)
                }
                Spacer()
            }
            .toolbar {
                Button {
                    showingSettings = true
                } label: {
                    Image(systemName: "gear")
                }
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView(vm: vm)
            }
            .onAppear {
                vm.fetchWeather(lat: lat, lon: lon)
            }
            .navigationTitle("Weather App")
        }
    }
    
    private func getCoordinates(for city: String) {
        // This example uses pre-set coords for a few cities
        switch city.lowercased() {
        case "london":
            lat = 51.5072; lon = -0.1276
        case "paris":
            lat = 48.8566; lon = 2.3522
        case "new york":
            lat = 40.7128; lon = -74.0060
        case "astana":
            lat = 51.1694; lon = 71.4491
        default:
            lat = 51.5072; lon = -0.1276
        }
        vm.fetchWeather(lat: lat, lon: lon)
    }
}
