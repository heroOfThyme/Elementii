//
//  ElementListView.swift
//  Elementii
//
//  Created by Petar Vidakovic on 2025-03-01.
//

import SwiftUI

struct ElementListView: View {
    @ObservedObject private var dataStore = ElementDataStore.shared
    @State private var searchText = ""
    @State private var filteredElements: [Element] = []
    @State private var isSearching = false
    @State private var searchBarActive = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Search bar with optimized behavior
            HStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                        .padding(.leading, 8)
                    
                    // The search field now has optimized tap handling
                    ZStack(alignment: .leading) {
                        if searchText.isEmpty && !searchBarActive {
                            Text("Search elements...")
                                .foregroundColor(.gray)
                                .padding(.vertical, 10)
                        }
                        
                        TextField("", text: $searchText)
                            .padding(.vertical, 10)
                            .disableAutocorrection(true)
                            .autocapitalization(.words)
                            .onChange(of: searchText) {
                                withAnimation {
                                    isSearching = true
                                }
                                
                                // Debounce search for better performance during typing
                                let searchQuery = searchText
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    // Only perform search if text hasn't changed
                                    if searchQuery == searchText {
                                        performSearch()
                                    }
                                }
                            }
                            .onTapGesture {
                                // This prevents the initial delay by only performing UI updates
                                withAnimation {
                                    searchBarActive = true
                                }
                                // Show search indicator if indexes aren't ready yet
                                if !dataStore.searchIndexesReady {
                                    withAnimation {
                                        isSearching = true
                                    }
                                }
                            }
                    }
                    
                    if isSearching {
                        ProgressView()
                            .padding(.trailing, 8)
                    } else if !searchText.isEmpty {
                        Button(action: {
                            searchText = ""
                            performSearch()
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                        .padding(.trailing, 8)
                    }
                }
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
            }
            .padding()
            
            // Show loading view or content
            if dataStore.isLoading {
                VStack(spacing: 16) {
                    ProgressView()
                        .scaleEffect(1.5)
                        .padding()
                    
                    Text("Loading Elements...")
                        .font(.headline)
                        .foregroundColor(Theme.text.opacity(0.7))
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Theme.background)
            } else {
                // Elements list - now using LazyVStack for better performance with many elements
                ScrollView {
                    LazyVStack(spacing: 0) {
                        if filteredElements.isEmpty && !searchText.isEmpty {
                            noResultsView
                        } else {
                            ForEach(filteredElements, id: \.atomicNumber) { element in
                                NavigationLink(destination: ElementDetailView(element: element)) {
                                    elementRow(element: element)
                                }
                                .buttonStyle(PlainButtonStyle())
                                
                                Divider()
                                    .padding(.leading, 50)
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Elements")
        .background(Theme.background)
        .onAppear {
            // Initialize filtered elements when view appears
            if filteredElements.isEmpty {
                filteredElements = dataStore.elements
            }
            
            // Pre-warm search
            preWarmSearch()
        }
    }
    
    // MARK: - Helper Views
    
    private var noResultsView: some View {
        VStack(spacing: 20) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 40))
                .foregroundColor(Theme.text.opacity(0.5))
                .padding(.top, 60)
            
            Text("No elements found")
                .font(.headline)
                .foregroundColor(Theme.text)
            
            Text("Try a different search term")
                .font(.subheadline)
                .foregroundColor(Theme.text.opacity(0.7))
        }
    }
    
    // MARK: - Helper Functions
    
    // Pre-warm search to avoid first-time lag
    private func preWarmSearch() {
        // Execute a dummy search to ensure indexes are ready
        DispatchQueue.global(qos: .userInitiated).async {
            _ = dataStore.searchElements(query: "")
            
            // This ensures the search won't lag when first tapped
            DispatchQueue.main.async {
                isSearching = false
            }
        }
    }
    
    // Search with proper UI updates
    private func performSearch() {
        // Get results from optimized data store
        let results = dataStore.searchElements(query: searchText)
        
        // Update UI
        withAnimation {
            filteredElements = results
            isSearching = false
        }
    }
    
    // Element list row (your existing implementation)
    private func elementRow(element: Element) -> some View {
        HStack {
            // Element symbol in colored circle
            ZStack {
                Circle()
                    .fill(element.categoryColor)
                    .frame(width: 40, height: 40)
                
                Text(element.symbol)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
            }
            
            // Element details
            VStack(alignment: .leading, spacing: 4) {
                Text(element.name)
                    .font(.headline)
                    .foregroundColor(Theme.text)
                
                HStack {
                    Text("\(element.atomicNumber)")
                        .font(.subheadline)
                        .foregroundColor(Theme.text)
                    
                    Text("•")
                        .foregroundColor(Theme.text)
                    
                    Text(element.category)
                        .font(.subheadline)
                        .foregroundColor(element.categoryColor)
                }
            }
            .padding(.leading, 8)
            
            Spacer()
            
            // Atomic weight
            Text(String(format: "%.3f", element.atomicWeight))
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(Theme.text)
        }
        .padding(.vertical, 6)
        .padding(.horizontal, 16)
        .contentShape(Rectangle()) // Ensures tap target fills the entire row
    }
}

#Preview {
    NavigationView {
        ElementListView()
    }
}
