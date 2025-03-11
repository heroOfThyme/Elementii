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
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack(alignment: .leading) {
            periodicTable
                .padding(.top, 2)
                .padding(.leading, 16)
        }
        .background(Theme.background)
        .navigationTitle("The Periodic Table")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    showLegendModal = true
                }) {
                    Image(systemName: "info.square.fill")
                        .foregroundColor(Theme.primary)
                }
            }
        }
        .sheet(isPresented: $showLegendModal) {
            NavigationView {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // Element Classifications Section
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Element Classifications")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(Theme.text)
                                .padding(.horizontal)
                                .padding(.top, 16)
                            
                            VStack(alignment: .leading, spacing: 12) {
                                EnhancedCategoryLegendItem(
                                    name: "Alkali Metal",
                                    color: Color("Alkali Metal"),
                                    description: "Highly reactive metals that readily lose their outermost electron. Found in Group 1 of the periodic table."
                                )
                                
                                EnhancedCategoryLegendItem(
                                    name: "Alkaline Earth Metal",
                                    color: Color("Alkaline Earth Metal"),
                                    description: "Reactive metals with two electrons in their outermost shell. Found in Group 2 of the periodic table."
                                )
                                
                                EnhancedCategoryLegendItem(
                                    name: "Transition Metal",
                                    color: Color("Transition Metal"),
                                    description: "Metals that form one or more stable ions with incompletely filled d-orbitals. Located in the middle of the periodic table."
                                )
                                
                                EnhancedCategoryLegendItem(
                                    name: "Post-Transition Metal",
                                    color: Color("Post-Transition Metal"),
                                    description: "Metals with properties between transition metals and metalloids. Often have complete d-subshells."
                                )
                                
                                EnhancedCategoryLegendItem(
                                    name: "Metalloid",
                                    color: Color("Metalloid"),
                                    description: "Elements with properties of both metals and nonmetals. Often semiconductors with intermediate conductivity."
                                )
                                
                                EnhancedCategoryLegendItem(
                                    name: "Nonmetal",
                                    color: Color("Nonmetal"),
                                    description: "Elements that are poor conductors of heat and electricity. Usually gain electrons in reactions with metals."
                                )
                                
                                EnhancedCategoryLegendItem(
                                    name: "Halogen",
                                    color: Color("Halogen"),
                                    description: "Highly reactive nonmetals that readily gain one electron to form anions. Found in Group 17 of the periodic table."
                                )
                                
                                EnhancedCategoryLegendItem(
                                    name: "Noble Gas",
                                    color: Color("Noble Gas"),
                                    description: "Extremely stable, nonreactive elements with full outer electron shells. Found in Group 18 of the periodic table."
                                )
                                
                                EnhancedCategoryLegendItem(
                                    name: "Lanthanide",
                                    color: Color("Lanthanide"),
                                    description: "Rare earth elements with atomic numbers 57-71. Have partially filled f-orbitals and similar properties."
                                )
                                
                                EnhancedCategoryLegendItem(
                                    name: "Actinide",
                                    color: Color("Actinide"),
                                    description: "Radioactive elements with atomic numbers 89-103. Have partially filled f-orbitals and many are synthetic."
                                )
                            }
                            .padding(.horizontal, 16)
                            .padding(.bottom, 16)
                        }
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(12)
                        .padding(.horizontal)

                        // Element Tile Anatomy Section
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Element Tile Anatomy")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(Theme.text)
                                .padding(.horizontal, 16)
                                .padding(.top, 16)
                            
                            HStack(alignment: .center, spacing: 20) {
                                // Example element tile
                                VStack(alignment: .center, spacing: 2) {
                                    Text("11")
                                        .font(.system(size: 14))
                                        .foregroundColor(.white)
                                    
                                    Text("Na")
                                        .font(.system(size: 32, weight: .bold))
                                        .foregroundColor(.white)
                                        .padding(.vertical, 4)
                                    
                                    Text("Sodium")
                                        .font(.system(size: 13))
                                        .foregroundColor(.white)
                                    
                                    Text("22.990")
                                        .font(.system(size: 13))
                                        .foregroundColor(.white)
                                        .padding(.top, 2)
                                        .padding(.bottom, 6)
                                }
                                .frame(width: 120, height: 120)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color("Alkali Metal"))
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                )
                                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                                
                                // Labels beside the element block
                                VStack(alignment: .leading, spacing: 14) {
                                    AnatomyLabelItem(number: 1, text: "Atomic number", alignment: .top)
                                    AnatomyLabelItem(number: 2, text: "Element symbol", alignment: .center)
                                    AnatomyLabelItem(number: 3, text: "Element name", alignment: .center)
                                    AnatomyLabelItem(number: 4, text: "Atomic weight (u)", alignment: .bottom)
                                }
                                
                                Spacer()
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                        }
                        .padding(.bottom, 16)
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(12)
                        .padding(.horizontal)
                        
                        // Table Structure Section
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Table Structure")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(Theme.text)
                                .padding(.horizontal)
                            
                            VStack(alignment: .leading, spacing: 12) {
                                StructureItem(
                                    icon: "tablecells",
                                    title: "Organization",
                                    description: "The periodic table is organized into 18 vertical columns (groups) and 7 horizontal rows (periods)."
                                )
                                
                                StructureItem(
                                    icon: "arrow.down",
                                    title: "Groups (Columns)",
                                    description: "Elements in the same group share similar chemical properties due to having the same number of electrons in their outer shell."
                                )
                                
                                StructureItem(
                                    icon: "arrow.right",
                                    title: "Periods (Rows)",
                                    description: "Elements in the same period have the same number of electron shells. As you move right, atomic number increases and properties change predictably."
                                )
                                
                                StructureItem(
                                    icon: "arrow.up.and.down",
                                    title: "Special Series",
                                    description: "Lanthanides (57-71) and Actinides (89-103) are placed separately below the main table to keep it from becoming too wide."
                                )
                                
                                StructureItem(
                                    icon: "atom",
                                    title: "Electron Configuration",
                                    description: "The table structure reflects electron shell filling, with each block (s, p, d, f) representing different subshells."
                                )
                            }
                            .padding(.horizontal)
                        }
                        .padding(.vertical, 16)
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(12)
                        .padding(.horizontal)
                        
                        // Interactive Tips Section
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Interactive Tips")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(Theme.text)
                                .padding(.horizontal, 16)
                                .padding(.top, 16)
                            
                            VStack(alignment: .leading, spacing: 12) {
                                InteractiveTipItem(
                                    icon: "hand.tap.fill",
                                    tip: "Tap any element to view its detailed information and properties."
                                )
                                
                                InteractiveTipItem(
                                    icon: "arrow.left.and.right.circle",
                                    tip: "Swipe to scroll horizontally across the periodic table."
                                )
                            }
                            .padding(.horizontal, 16)
                            .padding(.bottom, 16)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)  // This forces the VStack to take up all available width
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(12)
                        .padding(.horizontal)
                    }
                    .padding(.vertical, 20)
                }
                .navigationTitle("Periodic Table Legend")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Done") {
                            showLegendModal = false
                        }
                    }
                }
                .background(Theme.background)
            }
            .presentationDetents([.medium, .large])
            .presentationDragIndicator(.visible)
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
            .fill(Theme.primary)
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
                    .foregroundStyle(Theme.text)
            }
    }
    
    // Column header tile
    private func groupHeaderTile(group: Int) -> some View {
        RoundedRectangle(cornerRadius: 8)
            .strokeBorder(Color.secondary.opacity(0.2), lineWidth: 2)
            .frame(width: 78, height: 36)
            .overlay {
                Text("\(group)")
                    .foregroundStyle(Theme.text)
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
            .foregroundStyle(Theme.secondary.opacity(0.1))
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
                    .foregroundStyle(Color.white)
                    .frame(maxWidth: .infinity, alignment: .center)
                                
                // Element symbol
                Text(element.symbol)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(Color.white)
                    .frame(height: 26)
                
                // Element name
                Text(element.name)
                    .font(.system(size: 9))
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .foregroundStyle(Color.white)
                
                // Atomic weight
                Text(String(format: "%.3f", element.atomicWeight))
                    .font(.system(size: 9))
                    .foregroundStyle(Color.white.opacity(0.9))
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

// Enhanced category item with description
struct EnhancedCategoryLegendItem: View {
    let name: String
    let color: Color
    let description: String
    
    var body: some View {
        HStack(alignment: .top) {
            // Color square with fixed position
            RoundedRectangle(cornerRadius: 6)
                .fill(color)
                .frame(width: 24, height: 24)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                )
            
            // Text content with consistent spacing
            VStack(alignment: .leading, spacing: 4) {
                Text(name)
                    .font(.headline)
                    .foregroundColor(Theme.text)
                
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(Theme.text.opacity(0.8))
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.leading, 12)
        }
        .padding(.vertical, 8)
    }
}

// Anatomy label item with connector
struct AnatomyLabelItem: View {
    let number: Int
    let text: String
    let alignment: Alignment
    
    var body: some View {
        HStack(spacing: 10) {
            ZStack {
                Circle()
                    .fill(Theme.primary)
                    .frame(width: 24, height: 24)
                
                Text("\(number)")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
            }
            
            Text(text)
                .font(.system(size: 15))
                .foregroundColor(Theme.text)
        }
    }
}

// Structure item with icon
struct StructureItem: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(Theme.primary)
                .frame(width: 28, height: 28)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(Theme.text)
                
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(Theme.text.opacity(0.8))
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(.vertical, 6)
    }
}

// Interactive tip item
struct InteractiveTipItem: View {
    let icon: String
    let tip: String
    
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(Theme.accent)
                .frame(width: 28, height: 28)
            
            Text(tip)
                .font(.subheadline)
                .foregroundColor(Theme.text)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.vertical, 6)
    }
}

#Preview {
    NavigationView {
        PeriodicTableView()
    }
}
