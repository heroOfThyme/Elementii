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
    
    // Fixed size for consistency across all elements
    private let maxOrbitRadius: CGFloat = 170
    private let nucleusSize: CGFloat = 40
    private let electronSize: CGFloat = 10
    
    // Animation states
    @State private var isPulsing = false
    @State private var animationToggle = false
    
    var body: some View {
        let shellCounts = calculateElectronsPerShell()
        let sortedShells = shellCounts.keys.sorted()
        
        ZStack {
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
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(colorScheme == .dark ? .black : .white)
                )
            
            // Draw electron shells and electrons
            ForEach(sortedShells.indices, id: \.self) { index in
                let shellNumber = sortedShells[index]
                let electronCount = shellCounts[shellNumber] ?? 0
                let radius = calculateOrbitRadius(for: index, totalShells: sortedShells.count)
                
                // Draw orbit (ring) - no animation
                Circle()
                    .stroke(colorScheme == .dark ? Color.white.opacity(0.4) : Color.black.opacity(0.4), lineWidth: 1)
                    .frame(width: radius * 2, height: radius * 2)
                
                // Now create a rotating group for this shell
                ElectronShellView(
                    radius: radius,
                    electronCount: electronCount,
                    electronSize: electronSize,
                    shellIndex: index,
                    animationToggle: animationToggle
                )
            }
        }
        .frame(width: maxOrbitRadius * 2 + 20, height: maxOrbitRadius * 2 + 20)
        .onAppear {
            // Start the nucleus pulsing animation
            isPulsing = true
            
            // Start orbital rotation immediately
            animationToggle.toggle()
        }
    }
    
    // Calculate electrons per shell from the element's electron configuration
    private func calculateElectronsPerShell() -> [Int: Int] {
        // Parse the electron configuration
        let config = element.electronConfiguration
        let orbitals = config.split(separator: " ")
        
        var shellCounts: [Int: Int] = [:]
        
        for orbital in orbitals {
            if let shellNumber = getShellNumber(from: String(orbital)) {
                let electronCount = getElectronCount(from: String(orbital))
                shellCounts[shellNumber, default: 0] += electronCount
            }
        }
        
        return shellCounts
    }
    
    // Extract shell number from orbital notation
    private func getShellNumber(from orbital: String) -> Int? {
        guard let firstChar = orbital.first, let shellNumber = Int(String(firstChar)) else {
            return nil
        }
        return shellNumber
    }
    
    // Extract electron count from orbital notation
    private func getElectronCount(from orbital: String) -> Int {
        // Skip the first two characters (e.g., "1s") to get the superscript part
        guard orbital.count > 2 else { return 0 }
        
        // The rest should be superscript digits
        let startIndex = orbital.index(orbital.startIndex, offsetBy: 2)
        let superscriptPart = orbital[startIndex...]
        
        // Convert superscript digits to regular digits
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
        
        return Int(normalizedString) ?? 0
    }
    
    // Calculate the radius for each orbit with improved spacing from nucleus
    private func calculateOrbitRadius(for shellIndex: Int, totalShells: Int) -> CGFloat {
        // Add a minimum spacing from the nucleus for the first shell
        let nucleusOffset: CGFloat = 15.0  // Space between nucleus edge and first orbit
        
        // Calculate spacing between shells
        let availableRadius = maxOrbitRadius - (nucleusSize / 2 + nucleusOffset)
        let shellSpacing = availableRadius / CGFloat(max(totalShells, 1))
        
        // First shell starts at nucleus radius + offset
        return (nucleusSize / 2) + nucleusOffset + (shellSpacing * CGFloat(shellIndex))
    }
}

// Simplified component for each electron shell - only orbital animation
struct ElectronShellView: View {
    let radius: CGFloat
    let electronCount: Int
    let electronSize: CGFloat
    let shellIndex: Int
    let animationToggle: Bool
    
    // Use different rotation speeds for different shells
    private var rotationSpeed: Double {
        // Inner shells move faster (smaller period)
        return 10.0 + (Double(shellIndex) * 5.0)  // Seconds per full rotation
    }
    
    var body: some View {
        ZStack {
            ForEach(0..<electronCount, id: \.self) { i in
                // Place electrons evenly around the orbit
                let angle = (2 * Double.pi * Double(i)) / Double(electronCount)
                
                Circle()
                    .fill(Theme.primary)
                    .frame(width: electronSize, height: electronSize)
                    .shadow(color: Color.blue.opacity(0.7), radius: 3)
                    .offset(x: radius * cos(CGFloat(angle)), y: radius * sin(CGFloat(angle)))
            }
        }
        .rotationEffect(
            .degrees(animationToggle ? 360 : 0)
        )
        .animation(
            .linear(duration: rotationSpeed)
            .repeatForever(autoreverses: false),
            value: animationToggle
        )
    }
}
