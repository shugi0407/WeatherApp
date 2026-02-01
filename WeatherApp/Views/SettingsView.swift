import SwiftUI

struct SettingsView: View {
    @ObservedObject var vm: WeatherViewModel
    
    var body: some View {
        NavigationView {
            Form {
                Toggle("Use Fahrenheit", isOn: $vm.useFahrenheit)
            }
            .navigationTitle("Settings")
        }
    }
}
