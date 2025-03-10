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
    
    var body: some View {
        VStack(spacing: 0) {
            // Search bar
            HStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                        .padding(.leading, 8)
                    
                    TextField("Search elements...", text: $searchText)
                        .padding(10)
                        .onChange(of: searchText) {
                            updateFilteredElements()
                        }
                    
                    if !searchText.isEmpty {
                        Button(action: {
                            searchText = ""
                            updateFilteredElements()
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
            
            // Elements list
            List {
                // Main elements list
                ForEach(filteredElements, id: \.atomicNumber) { element in
                    NavigationLink(destination: ElementDetailView(element: element)) {
                        elementRow(element: element)
                    }
                }
            }
            .listStyle(PlainListStyle())
        }
        .navigationTitle("Elements")
        .background(Theme.background)
        .onAppear {
            // Initialize filtered elements when view appears
            if filteredElements.isEmpty {
                filteredElements = dataStore.elements
            }
        }
    }
    
    // Element list row remains the same as your original code
    private func elementRow(element: Element) -> some View {
        // Keep your existing implementation
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
    }
    
    // Update filtered elements using our optimized data store
    private func updateFilteredElements() {
        filteredElements = dataStore.searchElements(query: searchText)
    }
}

#Preview {
    NavigationView {
        ElementListView()
    }
}
