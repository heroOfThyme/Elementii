//
//  ContentView.swift
//  Elementii
//
//  Created by Petar Vidakovic on 2025-02-25.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    @State private var isThemeChanging = false
    
    var body: some View {
        ZStack {
            // Main TabView with content
            TabView {
                // Tab 1: Periodic Table Grid
                NavigationStack {
                    PeriodicTableView()
                }
                .tabItem {
                    Image(systemName: "square.grid.3x3.fill")
                    Text("Table")
                }
                
                // Tab 2: Element List
                NavigationStack {
                    ElementListView()
                }
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("List")
                }
                
                // Tab 3: Quiz/Game Area
                NavigationStack {
                    QuizSettingsView()
                }
                .tabItem {
                    Image(systemName: "gamecontroller")
                    Text("Quiz")
                }
                
                // Tab 4: Settings
                NavigationStack {
                    SettingsView()
                }
                .tabItem {
                    Image(systemName: "gearshape")
                    Text("Settings")
                }
            }
            .tint(Theme.primary)
        }
        .onChange(of: isDarkMode) { _, _ in
            handleThemeChange()
        }
        .onAppear {
            // Preemptively warm up element data in background
            _ = ElementDataStore.shared
        }
    }
    
    // Handle theme change with a smoother transition
    private func handleThemeChange() {
        // Show transition overlay
        withAnimation(.easeInOut(duration: 0.3)) {
            isThemeChanging = true
        }
        
        // Allow time for the system to process the change
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            // Hide transition overlay
            withAnimation(.easeInOut(duration: 0.3)) {
                isThemeChanging = false
            }
        }
    }
}

#Preview {
    ContentView()
}
