//
//  ContentView.swift
//  Elementii
//
//  Created by Petar Vidakovic on 2025-02-25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
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
}
