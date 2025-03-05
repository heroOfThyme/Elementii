//
//  PeriodicGridView.swift
//  Elementii
//
//  Created by Petar Vidakovic on 2025-03-01.
//

import SwiftUI

struct PeriodicGridView: View {
    let elements: [Element] = Bundle.main.decode("elements.json")
    @State private var showLegendPopover = false
    @State private var showCategoriesPopover = false
    @State private var selectedCategory: String? = nil
    @State private var offset = CGPoint.zero
    
    // List of element categories
    let categories = [
        "Actinide", "Alkali Metal", "Alkaline Earth Metal", "Halogen",
        "Lanthanide", "Metalloid", "Noble Gas", "Nonmetal",
        "Post-Transition Metal", "Transition Metal"
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            // Top toolbar with legend and categories buttons
            HStack {
                Button(action: {
                    showCategoriesPopover = true
                }) {
                    Label("Categories", systemImage: "square.grid.2x2.fill")
                        .font(.subheadline)
                        .padding(8)
                        .background(Color.secondary.opacity(0.1))
                        .cornerRadius(8)
                }
                .popover(isPresented: $showCategoriesPopover, arrowEdge: .top) {
                    CategoriesPopoverView(categories: categories, selectedCategory: $selectedCategory)
                        .presentationCompactAdaptation(.popover)
                        .frame(width: 300, height: 400)
                }
                
                Spacer()
                
                Button(action: {
                    showLegendPopover = true
                }) {
                    Label("Legend", systemImage: "info.circle.fill")
                        .font(.subheadline)
                        .padding(8)
                        .background(Color.secondary.opacity(0.1))
                        .cornerRadius(8)
                }
                .popover(isPresented: $showLegendPopover, arrowEdge: .top) {
                    LegendPopoverView()
                        .presentationCompactAdaptation(.popover)
                        .frame(width: 300, height: 400)
                }
            }
            .padding()
            
            // Main periodic table
            periodicTable
        }
        .navigationTitle("Periodic Table of Elements")
        .background(Theme.background)
    }
    
    // Main periodic table implementation
    private var periodicTable: some View {
        HStack(alignment: .top, spacing: 8) {
            // Row headers column
            VStack(alignment: .leading, spacing: 8) {
                // Origin tile (empty top-left corner)
                originTile
                
                // Row headers
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(1..<10) { row in
                            rowHeaderTile(row: row)
                                .padding(.top, row == 8 ? 16 : 0)
                        }
                    }
                    .offset(y: offset.y)
                }
                .disabled(true)
            }
            
            // Column headers and element grid
            VStack(alignment: .leading, spacing: 8) {
                // Column headers
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .top, spacing: 8) {
                        ForEach(1..<19) { group in
                            groupHeaderTile(group: group)
                        }
                    }
                    .offset(x: offset.x)
                }
                .disabled(true)
                
                // Scrollable element grid
                ScrollView([.horizontal, .vertical], showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(1..<10) { row in
                            HStack(alignment: .top, spacing: 8) {
                                ForEach(1..<19) { group in
                                    if row == 8 && group == 3 {
                                        // Lanthanides reference cell
                                        referenceCell(text: "57-71", color: Color("Lanthanide"))
                                    } else if row == 9 && group == 3 {
                                        // Actinides reference cell
                                        referenceCell(text: "89-103", color: Color("Actinide"))
                                    } else if let element = elements.first(where: {
                                        $0.position.x == group && $0.position.y == row
                                    }) {
                                        // Element tile
                                        elementTile(for: element)
                                    } else {
                                        // Empty space
                                        emptyTile
                                    }
                                }
                            }
                            .padding(.top, row == 8 ? 16 : 0)
                        }
                    }
                    .background(GeometryReader { geo in
                        Color.clear
                            .preference(key: ViewOffsetKey.self,
                                        value: geo.frame(in: .named("scroll")).origin)
                    })
                    .onPreferenceChange(ViewOffsetKey.self) { value in
                        offset = value
                    }
                }
                .coordinateSpace(name: "scroll")
            }
        }
        .padding(.leading, 16)
        .padding(.top, 8)
    }
    
    // Origin tile (top-left corner)
    private var originTile: some View {
        RoundedRectangle(cornerRadius: 8)
            .frame(width: 36, height: 36)
            .foregroundStyle(Color.secondary.opacity(0.1))
    }
    
    // Column header tile
    private func groupHeaderTile(group: Int) -> some View {
        RoundedRectangle(cornerRadius: 8)
            .strokeBorder(Color.secondary.opacity(0.2), lineWidth: 2)
            .frame(width: 78, height: 36)
            .overlay {
                Text(group.romanNumeral)
                    .foregroundStyle(Color.secondary)
            }
    }
    
    // Row header tile
    private func rowHeaderTile(row: Int) -> some View {
        let rowText = row == 8 ? "L" : row == 9 ? "A" : "\(row)"
        
        return RoundedRectangle(cornerRadius: 8)
            .strokeBorder(Color.secondary.opacity(0.2), lineWidth: 2)
            .frame(width: 36, height: 94)
            .overlay {
                Text(rowText)
                    .font(.system(size: 20))
                    .foregroundStyle(Color.secondary)
            }
    }
    
    // Element tile
    private func elementTile(for element: Element) -> some View {
        NavigationLink(destination: ElementDetailView(element: element)) {
            VStack(spacing: 1) {
                // Atomic number
                Text("\(element.atomicNumber)")
                    .font(.system(size: 10))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                // Element symbol
                Text(element.symbol)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                    .frame(height: 26)
                
                // Element name
                Text(element.name)
                    .font(.system(size: 9))
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .foregroundColor(.white)
                
                // Atomic weight
                Text(String(format: "%.3f", element.atomicWeight))
                    .font(.system(size: 9))
                    .foregroundColor(.white.opacity(0.9))
                    .padding(.top, 2)
            }
            .padding(4)
            .frame(width: 78, height: 94)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(getElementColor(element))
            )
        }
    }
    
    // Empty tile
    private var emptyTile: some View {
        Rectangle()
            .fill(Color.clear)
            .frame(width: 78, height: 94)
    }
    
    // Lanthanide/Actinide reference cell
    private func referenceCell(text: String, color: Color) -> some View {
        RoundedRectangle(cornerRadius: 8)
            .frame(width: 78, height: 94)
            .foregroundStyle(Color.secondary.opacity(0.1))
            .overlay {
                VStack {
                    Spacer()
                    Text(text)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(color)
                    Spacer()
                }
            }
    }
    
    // Determine element color based on filtering
    private func getElementColor(_ element: Element) -> Color {
        let matchesCategory = selectedCategory == nil || element.category == selectedCategory
        
        // Normal color if matches category filter, dimmed color otherwise
        return element.categoryColor.opacity(matchesCategory ? 1.0 : 0.3)
    }
}

// Extension to convert integer to Roman numeral (for column headers)
extension Int {
    var romanNumeral: String {
        let romanValues = ["I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX", "X",
                           "XI", "XII", "XIII", "XIV", "XV", "XVI", "XVII", "XVIII"]
        return self <= romanValues.count ? romanValues[self-1] : "\(self)"
    }
}

// Legend Popover View
struct LegendPopoverView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Element Categories")
                .font(.headline)
                .padding(.horizontal)
                .padding(.top)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(["Alkali Metal", "Alkaline Earth Metal", "Transition Metal",
                             "Post-Transition Metal", "Metalloid", "Nonmetal",
                             "Halogen", "Noble Gas", "Lanthanide", "Actinide"], id: \.self) { category in
                        HStack {
                            Circle()
                                .fill(Color(category))
                                .frame(width: 20, height: 20)
                            
                            Text(category)
                                .font(.subheadline)
                        }
                        .padding(.horizontal)
                    }
                    
                    Divider()
                        .padding(.vertical)
                    
                    Text("Element Tile Structure")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    HStack {
                        // Example element tile
                        VStack(spacing: 1) {
                            Text("11")
                                .font(.system(size: 10))
                                .foregroundColor(.white)
                            
                            Text("Na")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text("Sodium")
                                .font(.system(size: 9))
                                .foregroundColor(.white)
                            
                            Text("22.990")
                                .font(.system(size: 9))
                                .foregroundColor(.white)
                                .padding(.top, 2)
                        }
                        .padding(4)
                        .frame(width: 70, height: 70)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color("Alkali Metal"))
                        )
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Label("Atomic number", systemImage: "1.circle.fill")
                            Label("Symbol", systemImage: "2.circle.fill")
                            Label("Name", systemImage: "3.circle.fill")
                            Label("Weight", systemImage: "4.circle.fill")
                        }
                        .font(.caption)
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
}

// Categories Popover View
struct CategoriesPopoverView: View {
    let categories: [String]
    @Binding var selectedCategory: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Filter by Category")
                .font(.headline)
                .padding(.horizontal)
                .padding(.top)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    Button {
                        selectedCategory = nil
                    } label: {
                        HStack {
                            Text("All Categories")
                                .foregroundColor(.primary)
                            Spacer()
                            if selectedCategory == nil {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 4)
                    
                    Divider()
                    
                    ForEach(categories, id: \.self) { category in
                        Button {
                            selectedCategory = category
                        } label: {
                            HStack {
                                Circle()
                                    .fill(Color(category))
                                    .frame(width: 20, height: 20)
                                
                                Text(category)
                                    .foregroundColor(.primary)
                                
                                Spacer()
                                
                                if selectedCategory == category {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 4)
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
        value = nextValue()
    }
}

#Preview {
    NavigationView {
        PeriodicGridView()
    }
}
