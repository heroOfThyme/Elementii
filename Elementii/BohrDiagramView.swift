//
//  BohrDiagramView.swift
//  Elementii
//
//  Created by Petar Vidakovic on 2025-03-08.
//

import SwiftUI

struct BohrDiagramView: View {
    let element: Element
    @Environment(\.colorScheme) var colorScheme
    
    // Constants for sizing
    private let maxOrbitRadius: CGFloat = 160
    private let nucleusSize: CGFloat = 30
    private let electronSize: CGFloat = 12
    
    // Fixed number of rings (shells) for all elements
    private let numberOfRings = 7
    
    // Animation states
    @State private var electronAnimationStates: [String: Bool] = [:]
    @State private var isLoaded = false
    @State private var positions: [ElectronPosition] = []
    @State private var isPulsing = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Clear background with border
                Circle()
                    .fill(Color.clear)
                    .frame(width: maxOrbitRadius * 2 + 20, height: maxOrbitRadius * 2 + 20)
                
                // Nucleus with pulsing animation
                Circle()
                    .fill(element.categoryColor)
                    .shadow(color: element.categoryColor.opacity(0.7), radius: 5)
                    .frame(width: nucleusSize, height: nucleusSize)
                    .scaleEffect(isPulsing ? 1.1 : 1.0)
                    .animation(
                        Animation.easeInOut(duration: 2.0)
                            .repeatForever(autoreverses: true),
                        value: isPulsing
                    )
                    .overlay(
                        Text("\(element.atomicNumber)")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(colorScheme == .dark ? .black : .white)
                    )
                    .scaleEffect(isLoaded ? 1.0 : 0.5)
                    .animation(.spring(response: 0.6).delay(0.1), value: isLoaded)
                
                // Draw all rings and electrons
                ForEach(positions, id: \.id) { position in
                    // Ring path with animation
                    if position.isRing {
                        Circle()
                            .stroke(colorScheme == .dark ? Color.white.opacity(0.4) : Color.black.opacity(0.4), lineWidth: 1)
                            .frame(width: position.radius * 2, height: position.radius * 2)
                            .scaleEffect(isLoaded ? 1.0 : 0.1)
                            .opacity(isLoaded ? 1.0 : 0.0)
                            .animation(.spring(response: 0.6).delay(0.1 + Double(position.id.split(separator: "-")[1])! * 0.05), value: isLoaded)
                    }
                    
                    // Electron with animation
                    if !position.isRing {
                        ZStack {
                            // Electron glow effect
                            Circle()
                                .fill(Theme.primary.opacity(0.5))
                                .frame(width: electronSize * 1.5, height: electronSize * 1.5)
                                .scaleEffect(electronAnimationStates[position.id] ?? false ? 1.2 : 0.8)
                                .animation(
                                    Animation.easeInOut(duration: 1.5)
                                        .repeatForever(autoreverses: true)
                                        .delay(Double.random(in: 0...1)),
                                    value: electronAnimationStates[position.id] ?? false
                                )
                            
                            // Actual electron
                            Circle()
                                .fill(Color.blue)
                                .frame(width: electronSize, height: electronSize)
                                .shadow(color: Color.blue.opacity(0.7), radius: 3)
                        }
                        .offset(x: position.x, y: position.y)
                        .scaleEffect(isLoaded ? 1.0 : 0.1)
                        .opacity(isLoaded ? 1.0 : 0.0)
                        .animation(.spring(response: 0.6).delay(0.3 + Double.random(in: 0...0.5)), value: isLoaded)
                    }
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .position(x: geometry.size.width / 2, y: geometry.size.height / 2) // Center the diagram
            .onAppear {
                // Calculate positions on appear
                positions = computeElectronPositions()
                
                // Start animations
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    isLoaded = true
                    isPulsing = true
                    
                    // Start electron pulsing animations
                    for position in positions {
                        if !position.isRing {
                            electronAnimationStates[position.id] = true
                        }
                    }
                }
            }
        }
        .frame(width: 300, height: 300)
        .background(Color.clear)
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
    
    // Calculate the radius for each ring with better spacing
    private func calculateOrbitRadius(for ringIndex: Int) -> CGFloat {
        // Enhanced spacing with progressive increase
        let spacingMultipliers: [CGFloat] = [1.8, 3.2, 4.8, 6.6, 8.6, 10.8, 13.2]
        
        // Safety check
        let safeIndex = min(ringIndex, spacingMultipliers.count - 1)
        
        // Base unit
        let baseUnit = maxOrbitRadius / 14
        
        return baseUnit * spacingMultipliers[safeIndex]
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
    BohrDiagramView(element: Element(
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
        meltingPoint: nil,
        boilingPoint: nil,
        electronegativity: nil,
        discoveryYear: nil,
        discoveredBy: nil,
        funFacts: nil,
        compounds: nil,
        culturalReferences: nil,
        sustainabilityNotes: nil
    ))
}
