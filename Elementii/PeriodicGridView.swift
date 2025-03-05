//
//  PeriodicGridView.swift
//  Elementii
//
//  Created by Petar Vidakovic on 2025-03-01.
//

import SwiftUI

struct PeriodicGridView: View {
    let elements: [Element] = Bundle.main.decode("elements.json")
    @State private var showLegendModal = false
    @State private var showCategoriesModal = false
    @State private var selectedCategory: String? = nil // Track the selected category
    
    // List of element categories
    let categories = [
        "Actinide", "Alkali Metal", "Alkaline Earth Metal", "Halogen",
        "Lanthanide", "Metalloid", "Noble Gas", "Nonmetal",
        "Post-Transition Metal", "Transition Metal"
    ]
    
    @State private var offset = CGPoint.zero // Track scroll offset
    
    var body: some View {
        VStack(spacing: 0) {
            // Toolbar with Icons
            HStack {
                // Categories Icon
                Button(action: {
                    showCategoriesModal = true
                }) {
                    Image(systemName: "square.grid.2x2.fill")
                        .font(.headline)
                        .padding()
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(10)
                }
                .sheet(isPresented: $showCategoriesModal) {
                    CategoriesModalView(categories: categories, selectedCategory: $selectedCategory)
                }
                
                Spacer()
                
                // Legend Icon
                Button(action: {
                    showLegendModal = true
                }) {
                    Image(systemName: "info.circle.fill")
                        .font(.headline)
                        .padding()
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(10)
                }
                .sheet(isPresented: $showLegendModal) {
                    LegendModalView(showLegendModal: $showLegendModal)
                }
            }
            .padding(.horizontal)
            .padding(.top, 8)
            
            // Periodic Table Grid
            ZStack(alignment: .topLeading) {
                // Column Headers
                HStack(spacing: 8) {
                    // Empty space for the row headers
                    RoundedRectangle(cornerRadius: 8)
                        .frame(width: 36, height: 36)
                        .foregroundStyle(Color.clear)
                    
                    // Column numbers
                    ForEach(1..<19) { group in
                        RoundedRectangle(cornerRadius: 8)
                            .strokeBorder(Color.gray.opacity(0.3), lineWidth: 2)
                            .frame(width: 78, height: 36)
                            .overlay {
                                Text("\(group)")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                    }
                }
                .padding(.leading, 52) // Adjust for row headers
                .background(Theme.background) // Match background color
                .zIndex(1) // Ensure headers are above the scrollable content
                
                // Row Headers
                VStack(spacing: 8) {
                    // Empty space for the column headers
                    RoundedRectangle(cornerRadius: 8)
                        .frame(width: 36, height: 36)
                        .foregroundStyle(Color.clear)
                    
                    // Row numbers
                    ForEach(1..<10) { row in
                        RoundedRectangle(cornerRadius: 8)
                            .strokeBorder(Color.gray.opacity(0.3), lineWidth: 2)
                            .frame(width: 36, height: 94)
                            .overlay {
                                Text(row == 8 ? "L" : row == 9 ? "A" : "\(row)")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                    }
                }
                .padding(.top, 44) // Adjust for column headers
                .background(Theme.background) // Match background color
                .zIndex(1) // Ensure headers are above the scrollable content
                
                // Scrollable Tiles
                ScrollView([.horizontal, .vertical], showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(1..<10) { row in
                            HStack(alignment: .top, spacing: 8) {
                                ForEach(1..<19) { group in
                                    if row == 6 && group == 3 {
                                        // Lanthanides Tile
                                        RoundedRectangle(cornerRadius: 8)
                                            .frame(width: 78, height: 94)
                                            .foregroundStyle(Color.secondary.opacity(0.1))
                                            .overlay {
                                                Text("57-71")
                                                    .font(.headline)
                                                    .foregroundColor(.gray)
                                            }
                                    } else if row == 7 && group == 3 {
                                        // Actinides Tile
                                        RoundedRectangle(cornerRadius: 8)
                                            .frame(width: 78, height: 94)
                                            .foregroundStyle(Color.secondary.opacity(0.1))
                                            .overlay {
                                                Text("89-103")
                                                    .font(.headline)
                                                    .foregroundColor(.gray)
                                            }
                                    } else {
                                        // Element Tile
                                        if let element = elements.first(where: { $0.position.x == group && $0.position.y == row }) {
                                            NavigationLink(destination: ElementDetailView(element: element)) {
                                                ElementTile(element: element)
                                                    .opacity(selectedCategory == nil || element.category == selectedCategory ? 1 : 0.3) // Dim non-matching categories
                                            }
                                        } else {
                                            // Empty Tile
                                            RoundedRectangle(cornerRadius: 8)
                                                .frame(width: 78, height: 94)
                                                .foregroundStyle(Color.clear)
                                        }
                                    }
                                }
                            }
                            .padding(.leading, 52) // Adjust for row headers
                            .padding(.top, row == 8 ? 16 : 0)
                        }
                    }
                    .padding(.top, 44) // Adjust for column headers
                    .background(GeometryReader { geo in
                        Color.clear
                            .preference(key: ViewOffsetKey.self, value: geo.frame(in: .named("scroll")).origin)
                    })
                    .onPreferenceChange(ViewOffsetKey.self) { value in
                        offset = value
                    }
                }
                .coordinateSpace(name: "scroll")
            }
            .padding(.top, 8)
        }
        .navigationTitle("The Periodic Table of Elements")
        .background(Theme.background)
    }
}

// Category Label Component
struct CategoryLabel: View {
    let category: String
    
    var body: some View {
        HStack {
            Circle()
                .fill(Color(category)) // Use the color from Assets
                .frame(width: 20, height: 20)
            Text(category)
                .font(.subheadline)
                .lineLimit(1) // Ensure text fits in one line
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 10)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}

// Legend Modal Component
struct LegendModalView: View {
    @Binding var showLegendModal: Bool
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Title
                    Text("How to Read the Periodic Table")
                        .font(.largeTitle)
                        .bold()
                        .padding(.bottom, 10)
                    
                    // Introduction
                    Text("The periodic table organizes elements based on their atomic number, electron configuration, and recurring chemical properties. Here's a quick guide to understanding it:")
                        .font(.body)
                        .padding(.bottom, 10)
                    
                    // Sections
                    VStack(alignment: .leading, spacing: 15) {
                        // Groups and Periods
                        Text("1. **Groups and Periods**")
                            .font(.title2)
                            .bold()
                        Text("Elements are arranged in **18 vertical columns (groups)** and **7 horizontal rows (periods)**. Groups share similar chemical properties, while periods represent the number of electron shells.")
                            .font(.body)
                        
                        // Categories
                        Text("2. **Element Categories**")
                            .font(.title2)
                            .bold()
                        Text("Elements are color-coded based on their categories:")
                            .font(.body)
                        CategoryLabel(category: "Actinide")
                        CategoryLabel(category: "Alkali Metal")
                        CategoryLabel(category: "Alkaline Earth Metal")
                        CategoryLabel(category: "Halogen")
                        CategoryLabel(category: "Lanthanide")
                        CategoryLabel(category: "Metalloid")
                        CategoryLabel(category: "Noble Gas")
                        CategoryLabel(category: "Nonmetal")
                        CategoryLabel(category: "Post-Transition Metal")
                        CategoryLabel(category: "Transition Metal")
                    }
                    .padding()
                }
                .padding()
            }
            .navigationTitle("Legend")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        showLegendModal = false
                    }
                }
            }
        }
    }
}

struct ViewOffsetKey: PreferenceKey {
    typealias Value = CGPoint
    static var defaultValue = CGPoint.zero
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value.x += nextValue().x
        value.y += nextValue().y
    }
}
