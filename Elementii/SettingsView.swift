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
                    Image(systemName: "heart.rectangle")
                        .symbolRenderingMode(.multicolor)
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
                    .foregroundStyle(Theme.text)
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
                if let url = URL(string: "https://apps.apple.com/app/ 0") {
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

// Developer message view
struct DeveloperMessageView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        ZStack {
            // Solid background using Theme.background
            Theme.background
                .edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Header with icon
                    HStack {
                        Image(systemName: "atom")
                            .font(.system(size: 40))
                            .foregroundStyle(Theme.primary)
                        
                        VStack(alignment: .leading) {
                            Text("A Message from")
                                .font(.headline)
                                .foregroundColor(Theme.text.opacity(0.8))
                            
                            Text("The Developer")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(Theme.text)
                        }
                    }
                    .padding(.bottom, 8)
                    
                    // Divider line
                    Rectangle()
                        .frame(height: 2)
                        .foregroundStyle(Color.gray.opacity(0.3))
                        .padding(.bottom, 16)
                    
                    // Greeting
                    Text("Dear Elementii User,")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(Theme.text)
                    
                    // Message content in a card
                    VStack(alignment: .leading, spacing: 16) {
                        messageSection(
                            icon: "heart.fill",
                            color: .pink,
                            text: "Thank you for using Elementii! My name is Petar, and I am the developer behind Elementii. I wanted to create a mobile appllication as a learning curve into my developer journey - so, I figure why not make an application about one of my favourite things? Chemistry! Thus, Elementii was born."
                        )
                        
                        messageSection(
                            icon: "lightbulb.fill",
                            color: .yellow,
                            text: "My goal was to create an app that gave users information about elements, but also had a few differences from other chemistry apps. Each element model has several points and facts about the elements usage, sustainability, and much more. There's also a few small quizes to test your knowledge."
                        )
                        
                        messageSection(
                            icon: "info.square.fill",
                            color: .green,
                            text: "I am always looking for feedback and suggestions on how to improve the app. If you have any ideas or suggestions, please let me know!"
                        )
                        
                        messageSection(
                            icon: "storefront.fill",
                            color: .orange,
                            text: "I hope you enjoy using Elementii and that you find it useful! If you like the app, please consider leaving a review on the App Store!"
                        )
                        
                        Text("Thank you for your support!")
                            .font(.headline)
                            .foregroundColor(Theme.text)
                            .padding(.top, 8)
                        
                        HStack {
                            Spacer()
                            Text("Warm regards,")
                                .italic()
                                .foregroundColor(Theme.text.opacity(0.8))
                            Text("Petar Vidakovic")
                                .font(.headline)
                                .foregroundColor(Theme.primary)
                        }
                        .padding(.top, 4)
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(colorScheme == .dark ? Color(UIColor.systemGray6) : Color.white)
                            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                    )
                    
                    Spacer(minLength: 40)
                    
                    // Close button
                    Button(action: {
                        dismiss()
                    }) {
                        HStack {
                            Spacer()
                            Text("Close")
                                .font(.headline)
                            Spacer()
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    .tint(Theme.primary)
                    .shadow(color: Theme.primary.opacity(0.3), radius: 5, x: 0, y: 3)
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 36)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .background(Color.clear) // This ensures the background goes all the way down
    }
    
    // Helper function to create a consistent message section
    private func messageSection(icon: String, color: Color, text: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .foregroundStyle(color)
                .font(.system(size: 22))
                .frame(width: 26)
            
            Text(text)
                .foregroundColor(Theme.text)
                .fixedSize(horizontal: false, vertical: true)
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

