//
//  PeriodicTableView.swift
//  Elementii
//
//  Created on 2025-03-06.
//

import SwiftUI

struct ViewOffsetKey: PreferenceKey {
    typealias Value = CGPoint
    static var defaultValue = CGPoint.zero
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value.x += nextValue().x
        value.y += nextValue().y
    }
}

struct PeriodicTableView: View {
    let elements: [Element] = Bundle.main.decode("elements.json")
    
    @State private var showLegendModal = false
    @State private var offset = CGPoint.zero
    @State private var searchQuery: String = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            periodicTable
                .padding(.top, 2)
                .padding(.leading, 16)
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack {
                    Text("The Periodic Table")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(Color("AppPrimary"))
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    showLegendModal = true
                }) {
                    Image(systemName: "info.square.fill")
                        .foregroundColor(Color("AppPrimary"))
                }
            }
        }
        .sheet(isPresented: $showLegendModal) {
            NavigationView {
                VStack(alignment: .leading, spacing: 12) {
                    List {
                        Section(header: Text("Element Classifications")) {
                            CategoryLegendItem(name: "Alkali Metal", color: Color("Alkali Metal"))
                            CategoryLegendItem(name: "Alkaline Earth Metal", color: Color("Alkaline Earth Metal"))
                            CategoryLegendItem(name: "Transition Metal", color: Color("Transition Metal"))
                            CategoryLegendItem(name: "Post-Transition Metal", color: Color("Post-Transition Metal"))
                            CategoryLegendItem(name: "Metalloid", color: Color("Metalloid"))
                            CategoryLegendItem(name: "Nonmetal", color: Color("Nonmetal"))
                            CategoryLegendItem(name: "Halogen", color: Color("Halogen"))
                            CategoryLegendItem(name: "Noble Gas", color: Color("Noble Gas"))
                            CategoryLegendItem(name: "Lanthanide", color: Color("Lanthanide"))
                            CategoryLegendItem(name: "Actinide", color: Color("Actinide"))
                        }
                        
                        Section(header: Text("Element Tile Anatomy")) {
                            VStack(alignment: .center, spacing: 20) {
                                // Example element tile
                                VStack(alignment: .center, spacing: 1) {
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
                                .padding(5)
                                .frame(width: 80, height: 80)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color("Alkali Metal"))
                                )
                                
                                // Labels explaining each part
                                VStack(alignment: .leading, spacing: 10) {
                                    HStack {
                                        Image(systemName: "1.circle.fill")
                                            .foregroundColor(.primary)
                                        Text("Atomic number")
                                    }
                                    
                                    HStack {
                                        Image(systemName: "2.circle.fill")
                                            .foregroundColor(.primary)
                                        Text("Element symbol")
                                    }
                                    
                                    HStack {
                                        Image(systemName: "3.circle.fill")
                                            .foregroundColor(.primary)
                                        Text("Element name")
                                    }
                                    
                                    HStack {
                                        Image(systemName: "4.circle.fill")
                                            .foregroundColor(.primary)
                                        Text("Atomic weight (u)")
                                    }
                                }
                                .font(.system(size: 14))
                            }
                            .padding(.vertical)
                        }
                        
                        Section(header: Text("Table Structure")) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("• The periodic table is organized in 18 columns (groups) and 7 rows (periods)")
                                
                                Text("• Elements in the same group share similar chemical properties")
                                
                                Text("• Lanthanides (57-71) and Actinides (89-103) are placed below the main table")
                            }
                            .padding(.vertical, 8)
                        }
                    }
                }
                .navigationTitle("Periodic Table Legend")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Done") {
                            showLegendModal = false
                        }
                    }
                }
            }
            .presentationDetents([.medium, .large])
        }
    }
    
    // Main periodic table view
    private var periodicTable: some View {
        HStack(alignment: .top, spacing: 8) {
            // Add the row headers
            VStack(alignment: .leading, spacing: 8) {
                originTile
                ScrollView(.vertical) {
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(1..<8) { row in
                            rowHeaderTile(row: row)
                        }
                        // Lanthanide header
                        rowHeaderTile(row: 8)
                            .padding(.top, 16)
                        // Actinide header
                        rowHeaderTile(row: 9)
                    }
                    .offset(y: offset.y)
                }
                .disabled(true)
            }
            
            // Add the column headers and main periodic table
            VStack(alignment: .leading, spacing: 8) {
                // Column headers
                ScrollView(.horizontal) {
                    HStack(alignment: .top, spacing: 8) {
                        ForEach(1..<19) { group in
                            groupHeaderTile(group: group)
                        }
                    }
                    .offset(x: offset.x)
                }
                .disabled(true)
                
                // Main periodic table grid
                ScrollView([.horizontal, .vertical], showsIndicators: false) {
                    periodicTableGrid
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
        }
    }
    
    // Main periodic table grid layout
    private var periodicTableGrid: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(1..<8) { row in
                HStack(alignment: .top, spacing: 8) {
                    ForEach(1..<19) { group in
                        tileFor(group: group, row: row)
                    }
                }
            }
            
            // Extra spacing before lanthanide/actinide rows
            HStack(alignment: .top, spacing: 8) {
                ForEach(1..<19) { group in
                    tileFor(group: group, row: 8)
                }
            }
            .padding(.top, 16)
            
            HStack(alignment: .top, spacing: 8) {
                ForEach(1..<19) { group in
                    tileFor(group: group, row: 9)
                }
            }
        }
    }
    
    // Determine which type of tile to show at a given position
    private func tileFor(group: Int, row: Int) -> some View {
        // Special reference cells for lanthanides and actinides
        if row == 6 && group == 3 {
            return AnyView(referenceCell(text: "57-71", color: Color("Lanthanide")))
        }
        if row == 7 && group == 3 {
            return AnyView(referenceCell(text: "89-103", color: Color("Actinide")))
        }
        
        // Empty spaces in main table
        if (row == 1 && (2...17).contains(group)) ||
           ((2...3).contains(row) && (3...12).contains(group)) ||
           ((8...9).contains(row) && [1, 2, 18].contains(group)) {
            return AnyView(blankTile)
        }
        
        // Handle lanthanide row (row 8)
        if row == 8 && group >= 3 && group <= 17 {
            let atomicNumber = 54 + group  // Maps group 3 to element 57, group 4 to element 58, etc.
            if let element = elements.first(where: { $0.atomicNumber == atomicNumber }) {
                return AnyView(elementTile(for: element))
            }
        }
        
        // Handle actinide row (row 9)
        if row == 9 && group >= 3 && group <= 17 {
            let atomicNumber = 86 + group  // Maps group 3 to element 89, group 4 to element 90, etc.
            if let element = elements.first(where: { $0.atomicNumber == atomicNumber }) {
                return AnyView(elementTile(for: element))
            }
        }
        
        // Handle main table elements - exclude lanthanides and actinides
        if row <= 7 {
            if let element = elements.first(where: {
                $0.position.x == group && $0.position.y == row &&
                !((57...71).contains($0.atomicNumber) || (89...103).contains($0.atomicNumber))
            }) {
                return AnyView(elementTile(for: element))
            }
        }
        
        return AnyView(blankTile)
    }
    
    // Origin tile (top-left corner)
    private var originTile: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(Color.secondary.opacity(0.1))
            .frame(width: 36, height: 36)
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
    
    // Column header tile
    private func groupHeaderTile(group: Int) -> some View {
        RoundedRectangle(cornerRadius: 8)
            .strokeBorder(Color.secondary.opacity(0.2), lineWidth: 2)
            .frame(width: 78, height: 36)
            .overlay {
                Text("\(group)")
                    .foregroundStyle(Color.secondary)
            }
    }
    
    // Empty tile for blank spaces
    private var blankTile: some View {
        Rectangle()
            .frame(width: 78, height: 94)
            .opacity(0)
    }
    
    // Reference cell for lanthanides/actinides
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
                    .fill(element.categoryColor)
            )
        }
    }
}

// Helper struct for the legend view
struct CategoryLegendItem: View {
    let name: String
    let color: Color
    
    var body: some View {
        HStack {
            Circle()
                .fill(color)
                .frame(width: 24, height: 24)
            
            Text(name)
                .font(.body)
                .lineLimit(1)
            
            Spacer()
        }
    }
}

#Preview {
    NavigationView {
        PeriodicTableView()
    }
}
