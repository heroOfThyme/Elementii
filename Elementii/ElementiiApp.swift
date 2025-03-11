//
//  ElementiiApp.swift
//  Elementii
//
//  Created by Petar Vidakovic on 2025-02-25.
//
import SwiftUI
@main
struct ElementiiApp: App {
    // Initialize the data store as a shared environment object
    @ObservedObject private var dataStore = ElementDataStore.shared
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    init() {
        // Force immediate initialization of dataStore to start building indexes
        // This is like PocketChem's approach - start data processing right away
        let _ = ElementDataStore.shared
        
        // Configure any global UI settings
        configureAppAppearance()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
    
    // Optional UI configuration similar to PocketChem
    private func configureAppAppearance() {
        // Configure global UI appearance settings
        let appearance = UINavigationBarAppearance()
        
        // Configure with transparent background to remove default styling
        appearance.configureWithTransparentBackground()
        
        // Use your app's background color
        appearance.backgroundColor = UIColor(Theme.background)
        
        // Set text attributes
        appearance.titleTextAttributes = [.foregroundColor: UIColor(Theme.text)]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor(Theme.text)]
        
        // Remove shadow/border line
        appearance.shadowColor = nil
        appearance.shadowImage = UIImage()
        
        // Apply to all navigation bar styles
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        
        // Explicitly hide the navigation bar separator line
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
    }
}
