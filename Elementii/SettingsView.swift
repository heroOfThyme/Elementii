//
//  SettingsView.swift
//  Elementii
//
//  Created by Petar Vidakovic on 2025-03-01.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    @State private var showingDevMessage = false
    @Environment(\.openURL) private var openURL
    
    // App info
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
    
    var body: some View {
        Form {
            // Appearance section
            Section {
                Toggle(isOn: $isDarkMode) {
                    HStack {
                        Image(systemName: isDarkMode ? "moon.fill" : "sun.max.fill")
                            .foregroundColor(isDarkMode ? .blue : .yellow)
                        Text(isDarkMode ? "Dark Mode" : "Light Mode")
                    }
                }
            } header: {
                SectionHeaderWithIcon(
                    title: "Appearance",
                    systemName: "paintpalette.fill"
                )
            }
            
            // Notifications section
            Section {
                NavigationLink(destination: NotificationSettingsView()) {
                    Label("Notification Preferences", systemImage: "bell.badge")
                }
            } header: {
                SectionHeaderWithIcon(
                    title: "Notifications",
                    systemName: "bell.fill"
                )
            }
            
            // Message from the dev section
            Section {
                Button(action: {
                    showingDevMessage = true
                }) {
                    Label("Read Message from the Developer", systemImage: "envelope.open")
                }
                .sheet(isPresented: $showingDevMessage) {
                    DeveloperMessageView()
                }
            } header: {
                SectionHeaderWithIcon(
                    title: "Special Message",
                    systemName: "heart.fill"
                )
            }
            
            // About section
            Section {
                LabeledContent("Version") {
                    Text("\(appVersion) (\(buildNumber))")
                }
                
                Button(action: {
                    // Replace with your app's website URL
                    if let url = URL(string: "https://elementii-app.com") {
                        openURL(url)
                    }
                }) {
                    Label("Visit Website", systemImage: "globe")
                }
                
                Button(action: {
                    // Replace with your support email
                    if let url = URL(string: "mailto:support@elementii-app.com") {
                        openURL(url)
                    }
                }) {
                    Label("Contact Support", systemImage: "envelope")
                }
                
                Button(action: {
                    // Replace with your App Store URL
                    if let url = URL(string: "https://apps.apple.com/app/idYOURAPPID") {
                        openURL(url)
                    }
                }) {
                    Label("Rate on App Store", systemImage: "star.fill")
                }
            } header: {
                SectionHeaderWithIcon(
                    title: "About",
                    systemName: "info.circle.fill"
                )
            }
        }
        .navigationTitle("Settings")
        .preferredColorScheme(isDarkMode ? .dark : .light) // Apply the selected color scheme
    }
}

// Custom section header with icon
struct SectionHeaderWithIcon: View {
    let title: String
    let systemName: String
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: systemName)
                .foregroundColor(.accentColor)
            Text(title)
        }
    }
}

// A simple view for notifications settings
struct NotificationSettingsView: View {
    @AppStorage("pushNotificationsEnabled") private var pushNotificationsEnabled = true
    @AppStorage("emailNotificationsEnabled") private var emailNotificationsEnabled = false
    
    var body: some View {
        Form {
            Section(header: Text("Push Notifications")) {
                Toggle("Enable Push Notifications", isOn: $pushNotificationsEnabled)
                if pushNotificationsEnabled {
                    Toggle("New Updates", isOn: .constant(true))
                    Toggle("Feature Announcements", isOn: .constant(true))
                }
            }
            
            Section(header: Text("Email Notifications")) {
                Toggle("Enable Email Notifications", isOn: $emailNotificationsEnabled)
                if emailNotificationsEnabled {
                    Toggle("Weekly Newsletter", isOn: .constant(false))
                    Toggle("Special Offers", isOn: .constant(false))
                }
            }
        }
        .navigationTitle("Notifications")
    }
}

// Developer message view
struct DeveloperMessageView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("A Message from the Developer")
                    .font(.largeTitle)
                    .bold()
                
                Image(systemName: "person.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 60, height: 60)
                    .padding()
                    .background(Circle().fill(Color.accentColor.opacity(0.2)))
                
                Text("Dear Elementii User,")
                    .font(.title2)
                    .bold()
                
                Text("""
                Thank you for using Elementii! This app was created with passion to help you explore and understand the elements in a new and interactive way.
                
                I started this project because I wanted to create something that would make learning about chemistry both fun and accessible. Each feature has been carefully designed with you in mind.
                
                I'm constantly working on improvements and would love to hear your feedback. If you have suggestions or encounter any issues, please don't hesitate to reach out through the support email in the app.
                
                Thank you for your support!
                
                Warm regards,
                Petar
                """)
                .padding(.bottom)
                
                Spacer()
                
                Button("Close") {
                    // This will dismiss the sheet
                }
                .buttonStyle(.borderedProminent)
                .frame(maxWidth: .infinity)
            }
            .padding()
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SettingsView()
        }
    }
}
