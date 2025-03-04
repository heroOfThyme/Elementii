struct SettingsView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    var body: some View {
        Form {
            Section(header: Text("Appearance")) {
                Toggle("Dark Mode", isOn: $isDarkMode)
            }
            Section(header: Text("About")) {
                Text("Elementii v1.0")
                Text("Created with ❤️ by You")
            }
        }
        .navigationTitle("Settings")
    }
}