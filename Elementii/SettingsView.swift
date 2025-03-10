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
            appearanceSection
            messageFromDevSection
            aboutSection
        }
        .navigationTitle("Settings")
        .preferredColorScheme(isDarkMode ? .dark : .light) // Apply the selected color scheme
        .background(Theme.background)
    }
    
    // MARK: - Sections
    
    @ViewBuilder
    private var appearanceSection: some View {
        Section(header: Text("Appearance")) {
            Toggle(isOn: $isDarkMode) {
                HStack {
                    Image(systemName: isDarkMode ? "moon.fill" : "sun.max.fill")
                        .foregroundColor(isDarkMode ? .blue : .yellow)
                    Text(isDarkMode ? "Dark Mode" : "Light Mode")
                        .foregroundStyle(Theme.text)
                }
            }
        }
    }
    
    @ViewBuilder
    private var messageFromDevSection: some View {
        Section(header: Text("Special Message")) {
            Button(action: {
                showingDevMessage = true
            }) {
                HStack {
                    Image(systemName: "envelope.badge.person.crop.fill")
                        .foregroundStyle(Color.pink)
                        .font(.system(size: 18))
                        .frame(width: 24, height: 24)
                    
                    Text("Message from the Developer")
                        .foregroundStyle(Theme.text)
                }
                .frame(height: 36)
            }
            .sheet(isPresented: $showingDevMessage) {
                DeveloperMessageView()
            }
        }
    }
    
    @ViewBuilder
    private var aboutSection: some View {
        Section(header: Text("About")) {
            HStack {
                Image(systemName: "info.circle.fill")
                    .foregroundStyle(Color.purple)
                    .font(.system(size: 18))
                    .frame(width: 24, height: 24)
                
                Text("Version")
                    .foregroundStyle(Theme.text)
                
                Spacer()
                
                Text("\(appVersion) (\(buildNumber))")
                    .foregroundStyle(Theme.text)
            }
            .frame(height: 36)
            
            Button(action: {
                if let url = URL(string: "https://elementii-app.com") {
                    openURL(url)
                }
            }) {
                HStack {
                    Image(systemName: "globe.americas.fill")
                        .foregroundStyle(Color.green)
                        .font(.system(size: 18))
                        .frame(width: 24, height: 24)
                    
                    Text("Visit Website")
                        .foregroundStyle(Theme.text)
                }
                .frame(height: 36)
            }
            
            Button(action: {
                if let url = URL(string: "mailto:support@elementii-app.com") {
                    openURL(url)
                }
            }) {
                HStack {
                    Image(systemName: "envelope.front.fill")
                        .foregroundStyle(Color.red)
                        .font(.system(size: 18))
                        .frame(width: 24, height: 24)
                    
                    Text("Contact Support")
                        .foregroundStyle(Color.primary)
                }
                .frame(height: 36)
            }
            
            Button(action: {
                if let url = URL(string: "https://apps.apple.com/app/idYOURAPPID") {
                    openURL(url)
                }
            }) {
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundStyle(Color.yellow)
                        .font(.system(size: 18))
                        .frame(width: 24, height: 24)
                    
                    Text("Rate on App Store")
                        .foregroundStyle(Theme.text)
                }
                .frame(height: 36)
            }
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
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("A Message from the Developer")
                    .font(.largeTitle)
                    .bold()
                
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
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                .tint(Theme.primary)
                .frame(maxWidth: .infinity)
            }
            .padding()
            .background(Theme.background)
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
