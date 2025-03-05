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
    
    var body: some View {
        TabView {
            // Section 1: Element Symbol, Name, and Atomic Number
            VStack(spacing: 20) {
                Image(systemName: element.icon)
                    .font(.system(size: 100, weight: .regular))
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                    .symbolEffect(.breathe)
                
                Text(element.symbol)
                    .font(.system(size: 100, weight: .bold))
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                
                Text(element.name)
                    .font(.title)
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                
                Text("Atomic Number: \(element.atomicNumber)")
                    .font(.headline)
                    .foregroundColor(colorScheme == .dark ? .white.opacity(0.8) : .black.opacity(0.8))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
            .background(element.categoryColor.opacity(colorScheme == .dark ? 0.2 : 0.1))
            .tag(0)
            
            // Section 2: Atomic Weight and State
            VStack(spacing: 20) {
                Text("Atomic Weight: \(element.atomicWeight)")
                    .font(.title2)
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                
                Text("State: \(element.roomTempState)")
                    .font(.title2)
                    .foregroundColor(colorScheme == .dark ? .white : .black)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
            .background(element.categoryColor.opacity(colorScheme == .dark ? 0.2 : 0.1))
            .tag(1)
            
            // Section 3: Fun Fact
            ScrollView {
                VStack(spacing: 20) {
                    Text("Fun Fact")
                        .font(.title)
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                    
                    Text(element.fact)
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                        .padding()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
            .background(element.categoryColor.opacity(colorScheme == .dark ? 0.2 : 0.1))
            .tag(2)
            
            // Section 4: History
            ScrollView {
                VStack(spacing: 20) {
                    Text("History")
                        .font(.title)
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                    
                    Text(element.history)
                        .font(.body)
                        .multilineTextAlignment(.leading)
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                        .padding()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
            .background(element.categoryColor.opacity(colorScheme == .dark ? 0.2 : 0.1))
            .tag(3)
            
            // Section 5: Bohr Diagram
            VStack(spacing: 20) {
                Text("Bohr Diagram")
                    .font(.title)
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                
                BohrDiagramView(element: element)
                    .frame(width: 300, height: 300)
                    .padding()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
            .background(element.categoryColor.opacity(colorScheme == .dark ? 0.2 : 0.1))
            .tag(5)
            
            // Section 6: Applications
            ScrollView {
                VStack(spacing: 20) {
                    Text("Applications")
                        .font(.title)
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                    
                    ForEach(element.applications, id: \.self) { application in
                        Text("• \(application)")
                            .font(.body)
                            .multilineTextAlignment(.leading)
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                    }
                    .padding()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
            .background(element.categoryColor.opacity(colorScheme == .dark ? 0.2 : 0.1))
            .tag(4)
            
            // Section 7: Wikipedia Link
            VStack(spacing: 20) {
                Text("Learn More")
                    .font(.title)
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                
                Link("Visit Wikipedia", destination: URL(string: element.wikipediaLink)!)
                    .font(.headline)
                    .foregroundColor(.blue)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
            .background(element.categoryColor.opacity(colorScheme == .dark ? 0.2 : 0.1))
            .tag(5)
        }
        .tabViewStyle(.page(indexDisplayMode: .always)) // Enable pagination
        .indexViewStyle(.page(backgroundDisplayMode: .always)) // Show page indicators
        .edgesIgnoringSafeArea(.all)
        .background(element.categoryColor.opacity(colorScheme == .dark ? 0.2 : 0.1)) // Full-screen background
    }
}

struct BohrDiagramView: View {
    let element: Element
    
    // Constants for sizing
    private let maxOrbitRadius: CGFloat = 160 // Maximum radius for the outermost orbit
    private let nucleusSize: CGFloat = 25 // Size of the nucleus
    private let electronSize: CGFloat = 10 // Size of each electron
    
    // Fixed number of rings (shells) for all elements
    private let numberOfRings = 7 // Adjust as needed
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Nucleus
                Circle()
                    .fill(Color.red)
                    .frame(width: nucleusSize, height: nucleusSize)
                
                // Draw all rings and electrons
                let electronPositions = computeElectronPositions()
                ForEach(electronPositions, id: \.id) { position in
                    // Ring path
                    if position.isRing {
                        Circle()
                            .stroke(Color.gray, lineWidth: 1)
                            .frame(width: position.radius * 2, height: position.radius * 2)
                    }
                    
                    // Electron
                    if !position.isRing {
                        Circle()
                            .fill(Color.blue)
                            .frame(width: electronSize, height: electronSize)
                            .offset(x: position.x, y: position.y)
                    }
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .position(x: geometry.size.width / 2, y: geometry.size.height / 2) // Center the diagram
        }
        .frame(width: 300, height: 300) // Constrain the diagram to a fixed size
    }
    
    // Precompute electron positions
    private func computeElectronPositions() -> [ElectronPosition] {
        var positions: [ElectronPosition] = []
        var remainingElectrons = element.atomicNumber
        
        for ringIndex in 0..<numberOfRings {
            let orbitRadius = calculateOrbitRadius(for: ringIndex)
            
            // Add ring path
            positions.append(
                ElectronPosition(
                    id: "ring-\(ringIndex)",
                    radius: orbitRadius,
                    x: 0,
                    y: 0,
                    isRing: true
                )
            )
            
            // Calculate max electrons in this ring
            let maxElectronsInRing = maxElectrons(for: ringIndex)
            let electronsInRing = min(maxElectronsInRing, remainingElectrons)
            
            // Add electrons in this ring
            for electronIndex in 0..<electronsInRing {
                let angle = Double(electronIndex) * (2 * Double.pi / Double(electronsInRing))
                let x = orbitRadius * cos(CGFloat(angle))
                let y = orbitRadius * sin(CGFloat(angle))
                
                positions.append(
                    ElectronPosition(
                        id: "electron-\(ringIndex)-\(electronIndex)",
                        radius: 0,
                        x: x,
                        y: y,
                        isRing: false
                    )
                )
            }
            
            remainingElectrons -= electronsInRing
        }
        
        return positions
    }
    
    // Calculate the radius for each ring with extra spacing for the first ring
    private func calculateOrbitRadius(for ringIndex: Int) -> CGFloat {
        let baseSpacing = maxOrbitRadius / CGFloat(numberOfRings)
        
        // Add extra spacing for the first ring
        if ringIndex == 0 {
            return baseSpacing * CGFloat(ringIndex + 1) // Add 20 points of extra spacing
        } else {
            return baseSpacing * CGFloat(ringIndex + 1)
        }
    }
    
    // Calculate max electrons for a given ring
    private func maxElectrons(for ringIndex: Int) -> Int {
        // Electron shell configuration: [2, 8, 18, 32, 32, 18, 8]
        let electronShells = [2, 8, 18, 32, 32, 18, 8]
        return ringIndex < electronShells.count ? electronShells[ringIndex] : 0
    }
}

// Data structure to represent electron positions
struct ElectronPosition: Identifiable {
    let id: String
    let radius: CGFloat // Radius of the orbit (0 for electrons)
    let x: CGFloat // X offset
    let y: CGFloat // Y offset
    let isRing: Bool // Whether this is a ring or an electron
}

#Preview {
    ContentView()
}
