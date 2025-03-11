//
//  ElementDetailView.swift
//  Elementii
//
//  Created by Petar Vidakovic on 2025-02-25.
//

import SwiftUI

struct ElementDetailView: View {
    let element: Element
    @Environment(\.colorScheme) var colorScheme
    @State private var selectedTab = 0
    @State private var isShowingFact = false
    @State private var isSymbolAnimating = false
    
    private let tabTitles = ["Basics", "Properties", "History", "Uses", "Atom", "More"]
    private let tabIcons = ["info.circle", "list.bullet", "clock", "hammer", "atom", "ellipsis"]
    
    var body: some View {
        ZStack {
            // Background
            element.categoryColor.opacity(colorScheme == .dark ? 0.15 : 0.1)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                // Header with element basics
                ElementHeaderView(element: element)
                
                // Custom tab selector
                ScrollView(.horizontal, showsIndicators: true) {
                    HStack(spacing: 10) {
                        ForEach(0..<tabTitles.count, id: \.self) { index in
                            TabButton(
                                title: tabTitles[index],
                                icon: tabIcons[index],
                                isSelected: selectedTab == index,
                                accentColor: element.categoryColor
                            ) {
                                withAnimation {
                                    selectedTab = index
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 8)
                }
                
                // Content area
                TabView(selection: $selectedTab) {
                    // Tab 1: Basic Info
                    ElementBasicsView(element: element)
                        .tag(0)
                    
                    // Tab 2: Properties
                    ElementPropertiesView(element: element)
                        .tag(1)
                    
                    // Tab 3: History
                    ElementHistoryView(element: element)
                        .tag(2)
                    
                    // Tab 4: Applications
                    ElementApplicationsView(element: element)
                        .tag(3)
                    
                    // Tab 5: Bohr Diagram
                    ElementBohrView(element: element)
                        .tag(4)
                    
                    // Tab 6: More
                    ElementMoreView(element: element)
                        .tag(5)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.easeInOut, value: selectedTab)
            }
            
            // Fun Fact Popup
            if isShowingFact {
                FactPopupView(
                    fact: element.funFacts?.randomElement() ?? element.fact,
                    isShowing: $isShowingFact,
                    backgroundColor: element.categoryColor
                )
                .transition(.scale.combined(with: .opacity))
            }
        }
        .overlay(
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    
                    Button(action: {
                        withAnimation(.spring()) {
                            isShowingFact.toggle()
                        }
                    }) {
                        Image(systemName: "lightbulb.fill")
                            .font(.system(size: 24))
                            .foregroundStyle(element.categoryColor)
                            .padding()
                            .background(
                                Circle()
                                    .fill(colorScheme == .dark ? Color.black.opacity(0.7) : Color.white.opacity(0.7))
                                    .shadow(color: element.categoryColor.opacity(0.5), radius: 5)
                            )
                    }
                    .padding(.trailing, 20)
                    .padding(.bottom, 20)
                }
            }
        )
        .navigationTitle(element.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Tab Button
struct TabButton: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let accentColor: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .symbolEffect(.pulse, isActive: isSelected)
                Text(title)
                    .font(.caption)
                    .fontWeight(.bold)
            }
            .frame(maxHeight: .infinity)
            .foregroundStyle(isSelected ? .white : Theme.text)
            .frame(width: 75, height: 60) // Fixed width instead of stretching
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(isSelected ? accentColor : (colorScheme == .dark ? Color.black.opacity(0.3) : Color.white.opacity(0.5)))
            )
        }
    }
    
    @Environment(\.colorScheme) var colorScheme
}

// MARK: - Header View
struct ElementHeaderView: View {
    let element: Element
    @Environment(\.colorScheme) var colorScheme
    @State private var isSymbolAnimating = false
    
    var body: some View {
        HStack(spacing: 15) {
            // Element symbol with animation
            ZStack {
                Circle()
                    .fill(element.categoryColor.opacity(0.3))
                    .frame(width: 80, height: 80)
                
                Text(element.symbol)
                    .font(.system(size: 36, weight: .bold))
                    .foregroundStyle(colorScheme == .dark ? .white : .black)
                    .scaleEffect(isSymbolAnimating ? 1.1 : 1.0)
                    .animation(
                        Animation.easeInOut(duration: 1.5)
                            .repeatForever(autoreverses: true),
                        value: isSymbolAnimating
                    )
                    .onAppear {
                        isSymbolAnimating = true
                    }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(element.name)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(Theme.text)
                
                Text("Atomic Number: \(element.atomicNumber)")
                    .font(.subheadline)
                    .foregroundStyle(Theme.text.opacity(0.8))
                
                HStack(spacing: 10) {
                    Label(element.category, systemImage: element.categoryIcon)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(element.categoryColor.opacity(0.2))
                        .cornerRadius(5)
                }
            }
            
            Spacer()
            
            // Element icon with animation
            Image(systemName: element.categoryIcon)
                .font(.system(size: 32))
                .foregroundStyle(element.categoryColor)
                .symbolEffect(.pulse, options: .repeating)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(colorScheme == .dark ? Color.black.opacity(0.3) : Color.white.opacity(0.5))
        )
        .padding([.horizontal, .top])
    }
    
    // Helper function to determine color based on state
    private func stateColor(for state: String) -> Color {
        switch state.lowercased() {
        case "gas":
            return .blue
        case "liquid":
            return .teal
        case "solid":
            return .brown
        default:
            return .gray
        }
    }
}

// MARK: - Tab Content Views
struct ElementBasicsView: View {
    let element: Element
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Element symbol card
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(element.categoryColor.opacity(0.15))
                        .shadow(color: element.categoryColor.opacity(0.3), radius: 5)
                    
                    HStack {
                        Spacer()
                        
                        Text(element.symbol)
                            .font(.system(size: 120, weight: .bold))
                            .foregroundStyle(element.categoryColor.opacity(0.3))
                        
                        Spacer()
                    }
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Quick Facts")
                            .font(.title2)
                            .bold()
                            .padding(.bottom, 5)
                            
                        InfoRow(title: "Atomic Weight", value: "\(element.atomicWeight)")
                        InfoRow(title: "State at Room Temp", value: element.roomTempState)
                        InfoRow(title: "Category", value: element.category)
                        if let year = element.discoveryYear {
                            InfoRow(title: "Discovered", value: "\(year)")
                                .lineLimit(2)
                        }
                        if let discoverer = element.discoveredBy {
                            InfoRow(title: "Discovered By", value: discoverer)
                                .lineLimit(2)
                        }
                    }
                    .padding()
                }
                .frame(height: 230)
                .padding(.horizontal)
                .padding(.top)
                
                // Main fact
                VStack(alignment: .leading, spacing: 10) {
                    Text("Did You Know?")
                        .font(.title2)
                        .bold()
                    
                    Text(element.fact)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(colorScheme == .dark ? Color.black.opacity(0.2) : Color.white.opacity(0.5))
                        )
                }
                .padding(.horizontal)
                .padding(.top)
                
                // Wikipedia link
                Link(destination: URL(string: element.wikipediaLink)!) {
                    Text("Learn more on Wikipedia")
                        .foregroundStyle(Theme.primary)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.blue, lineWidth: 1)
                                .background(
                                    colorScheme == .dark ? Color.black.opacity(0.3) : Color.white.opacity(0.5)
                                )
                        )
                }
                .padding()
            }
            .padding(.bottom, 20)
        }
    }
}

struct InfoRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .font(.subheadline)
                .bold()
        }
    }
}

struct ElementPropertiesView: View {
    let element: Element
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ScrollView {
            VStack(spacing: 15) {
                Text("Physical & Chemical Properties")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.top)
                
                // Properties grid
                LazyVGrid(columns:
                            [GridItem(.fixed(UIScreen.main.bounds.width * 0.42), spacing: 15),
                             GridItem(.fixed(UIScreen.main.bounds.width * 0.42), spacing: 15)
                            ], spacing: 15) {
                    PropertyCard(title: "Atomic Weight", value: "\(element.atomicWeight)", icon: "scalemass", accentColor: element.categoryColor)
                    PropertyCard(title: "State", value: element.roomTempState, icon: "thermometer", accentColor: element.categoryColor)
                    
                    if let meltingPoint = element.meltingPoint {
                        PropertyCard(title: "Melting Point", value: meltingPoint, icon: "arrow.down.to.line", accentColor: element.categoryColor)
                    }
                    
                    if let boilingPoint = element.boilingPoint {
                        PropertyCard(title: "Boiling Point", value: boilingPoint, icon: "arrow.up.to.line", accentColor: element.categoryColor)
                    }
                    
                    if let electronegativity = element.electronegativity {
                        PropertyCard(title: "Electronegativity", value: "\(electronegativity)", icon: "bolt", accentColor: element.categoryColor)
                    }
                    
                    PropertyCard(title: "Category", value: element.category, icon: element.categoryIcon, accentColor: element.categoryColor)
                    
                    PropertyCard(title: "Period", value: "\(element.period)", icon: "arrow.left.and.right", accentColor: element.categoryColor)
                    PropertyCard(title: "Group", value: "\(element.group)", icon: "arrow.up.and.down", accentColor: element.categoryColor)
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .padding(.bottom, 20)
        }
    }
}

struct PropertyCard: View {
    let title: String
    let value: String
    let icon: String
    let accentColor: Color
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Icon and title row
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundStyle(accentColor)
                
                Text(title)
                    .font(.headline)
            }
            .foregroundStyle(.secondary)
            
            // Value with proper text wrapping
            Text(value)
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundStyle(.primary)
                .fixedSize(horizontal: false, vertical: true)
                .multilineTextAlignment(.leading)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 14)
        .frame(minHeight: 100)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(colorScheme == .dark ? Color.black.opacity(0.3) : Color.white.opacity(0.7))
                .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 2)
        )
    }
}

struct ElementHistoryView: View {
    let element: Element
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Discovery details
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Image(systemName: "clock.fill")
                            .foregroundStyle(element.categoryColor)
                        
                        Text("Discovery")
                            .font(.title2)
                            .bold()
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    
                    if let year = element.discoveryYear, let discoverer = element.discoveredBy {
                        Text(verbatim: "Discovered in \(year) by \(discoverer)")
                            .font(.headline)
                            .padding(.vertical, 5)
                            .padding(.horizontal)
                    }
                    
                    Divider()
                        .padding(.horizontal)
                }
                
                // History text
                Text(element.history)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(colorScheme == .dark ? Color.black.opacity(0.2) : Color.white.opacity(0.5))
                    )
                    .padding(.horizontal)
                
                Spacer(minLength: 20)
            }
            .padding(.bottom, 20)
        }
    }
}

struct ElementApplicationsView: View {
    let element: Element
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Applications & Uses")
                    .font(.title2)
                    .bold()
                    .padding(.horizontal)
                    .padding(.top)
                
                // Applications list
                ForEach(element.applications, id: \.self) { application in
                    HStack(alignment: .top, spacing: 15) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(element.categoryColor)
                            .font(.system(size: 22))
                        
                        Text(application)
                            .font(.body)
                    }
                    .padding(.horizontal)
                }
                
                // Sustainability notes if available
                if let sustainabilityNotes = element.sustainabilityNotes {
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Image(systemName: "leaf.fill")
                                .foregroundStyle(.green)
                            
                            Text("Sustainability")
                                .font(.headline)
                        }
                        .padding(.top)
                        .padding(.horizontal)
                        
                        Text(sustainabilityNotes)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.green.opacity(0.2))
                            )
                            .padding(.horizontal)
                    }
                }
                
                Spacer(minLength: 20)
            }
            .padding(.bottom, 20)
        }
    }
}

// In ElementDetailView.swift, replace the ElementBohrView struct with this:
struct ElementBohrView: View {
    let element: Element
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Title
                Text("Atomic Structure")
                    .font(.title2)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top)
                
                // Bohr model subtitle
                Text("Bohr Model of \(element.name)")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                // Bohr Diagram - contained in a fixed-size container with center alignment
                HStack {
                    Spacer()
                    BohrDiagramView(element: element)
                        .frame(width: 330, height: 330) // Fixed size for consistency
                        .padding(.vertical, 10)
                    Spacer()
                }
                
                // Electron Configuration section
                VStack(alignment: .leading, spacing: 12) {
                    Text("Electron Configuration")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    // Updated format to display in a stacked layout
                    VStack(alignment: .leading, spacing: 6) {
                        ForEach(element.formattedElectronConfiguration, id: \.self) { line in
                            Text(line)
                                .font(.system(.body, design: .monospaced))
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.gray.opacity(0.1))
                    )
                    .padding(.horizontal)
                }
                
                // Electrons per Shell section
                VStack(alignment: .leading, spacing: 12) {
                    Text("Electrons per Shell")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    Text(getElectronsPerShell(element: element))
                        .font(.system(.body, design: .monospaced))
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.gray.opacity(0.1))
                        )
                        .padding(.horizontal)
                }
                
                Spacer(minLength: 30)
            }
            .padding(.bottom, 20)
        }
    }
    
    // Helper function to calculate electrons per shell
    private func getElectronsPerShell(element: Element) -> String {
        // Parse the electron configuration
        let config = element.electronConfiguration
        let orbitals = config.split(separator: " ")
        
        var shellCounts: [Int: Int] = [:]
        
        for orbital in orbitals {
            if let firstChar = orbital.first, let shellNumber = Int(String(firstChar)) {
                // Extract electron count using same logic as in BohrDiagramView
                let orbitalString = String(orbital)
                guard orbitalString.count > 2 else { continue }
                
                let startIndex = orbitalString.index(orbitalString.startIndex, offsetBy: 2)
                let superscriptPart = orbitalString[startIndex...]
                
                var normalizedString = ""
                for char in superscriptPart {
                    switch char {
                    case "⁰": normalizedString += "0"
                    case "¹": normalizedString += "1"
                    case "²": normalizedString += "2"
                    case "³": normalizedString += "3"
                    case "⁴": normalizedString += "4"
                    case "⁵": normalizedString += "5"
                    case "⁶": normalizedString += "6"
                    case "⁷": normalizedString += "7"
                    case "⁸": normalizedString += "8"
                    case "⁹": normalizedString += "9"
                    default: normalizedString += String(char)
                    }
                }
                
                if let electronCount = Int(normalizedString) {
                    shellCounts[shellNumber, default: 0] += electronCount
                }
            }
        }
        
        // Format as string like "2, 8, 18, 18, 1"
        let sortedShells = shellCounts.keys.sorted()
        let countStrings = sortedShells.map { "\(shellCounts[$0] ?? 0)" }
        return countStrings.joined(separator: ", ")
    }
}
struct ElementMoreView: View {
    let element: Element
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Compounds if available
                if let compounds = element.compounds, !compounds.isEmpty {
                    Text("Common Compounds")
                        .font(.title2)
                        .bold()
                        .padding(.horizontal)
                        .padding(.top)
                    
                    ForEach(compounds, id: \.name) { compound in
                        VStack(alignment: .leading, spacing: 10) {
                            Text(compound.name)
                                .font(.headline)
                                .foregroundStyle(element.categoryColor)
                            
                            Text(compound.description)
                                .font(.body)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(colorScheme == .dark ? Color.black.opacity(0.2) : Color.white.opacity(0.5))
                        )
                        .padding(.horizontal)
                    }
                }
                
                // Cultural references if available
                if let references = element.culturalReferences, !references.isEmpty {
                    Text("In Culture & Media")
                        .font(.title2)
                        .bold()
                        .padding(.horizontal)
                        .padding(.top)
                    
                    ForEach(references, id: \.self) { reference in
                        HStack(alignment: .top, spacing: 15) {
                            Image(systemName: "star.fill")
                                .foregroundStyle(element.categoryColor)
                                .font(.system(size: 22))
                            
                            Text(reference)
                                .font(.body)
                        }
                        .padding(.horizontal)
                    }
                }
                
                // Fun facts if available
                if let funFacts = element.funFacts, !funFacts.isEmpty {
                    Text("Fun Facts")
                        .font(.title2)
                        .bold()
                        .padding(.horizontal)
                        .padding(.top)
                    
                    ForEach(funFacts, id: \.self) { fact in
                        HStack(alignment: .top, spacing: 15) {
                            Image(systemName: "lightbulb.fill")
                                .foregroundStyle(.yellow)
                                .font(.system(size: 22))
                            
                            Text(fact)
                                .font(.body)
                        }
                        .padding(.horizontal)
                    }
                }
                
                Spacer(minLength: 20)
            }
            .padding(.bottom, 20)
        }
    }
}

struct FactPopupView: View {
    let fact: String
    @Binding var isShowing: Bool
    let backgroundColor: Color
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    withAnimation(.spring()) {
                        isShowing = false
                    }
                }
            
            VStack(spacing: 20) {
                Image(systemName: "lightbulb.fill")
                    .font(.system(size: 40))
                    .foregroundStyle(backgroundColor)
                    .symbolEffect(.pulse, options: .repeating)
                
                Text("Did You Know?")
                    .font(.headline)
                
                Text(fact)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding()
                
                Button("Cool!") {
                    withAnimation(.spring()) {
                        isShowing = false
                    }
                }
                .padding(.horizontal, 40)
                .padding(.vertical, 10)
                .background(backgroundColor)
                .foregroundStyle(.white)
                .cornerRadius(20)
            }
            .padding(30)
            .background(Color(UIColor.systemBackground))
            .cornerRadius(20)
            .shadow(radius: 15)
            .padding(30)
        }
    }
}

#Preview {
    NavigationView {
        ElementDetailView(element: Element(
            name: "Hydrogen",
            symbol: "H",
            atomicNumber: 1,
            atomicWeight: 1.008,
            category: "Nonmetal",
            fact: "Hydrogen is the lightest element.",
            wikipediaLink: "https://en.wikipedia.org/wiki/Hydrogen",
            applications: ["Rocket fuel", "Fuel cells"],
            roomTempState: "Gas",
            history: "Discovered in 1766.",
            examples: [],
            icon: "wind",
            meltingPoint: "-259.16°C",
            boilingPoint: "-252.87°C",
            electronegativity: 2.20,
            discoveryYear: 1766,
            discoveredBy: "Henry Cavendish",
            funFacts: ["Hydrogen makes up 75% of the universe's mass."],
            compounds: [ElementCompound(name: "Water (H₂O)", description: "Essential for life.")],
            culturalReferences: ["Featured in Jules Verne's novels."],
            sustainabilityNotes: "Key to clean energy future."
        ))
    }
}
