//
//  Element.swift
//  Elementii
//
//  Created by Petar Vidakovic on 2025-02-25.
//

import Foundation
import SwiftUI

// Load the JSON data
extension Bundle {
    func decode<T: Decodable>(_ file: String) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in bundle.")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) from bundle.")
        }
        
        let decoder = JSONDecoder()
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            fatalError("Failed to decode \(file) from bundle: \(error)")
        }
    }
}

struct Element: Identifiable, Codable {
    let name: String
    let symbol: String
    let atomicNumber: Int
    var id: Int { atomicNumber }
    let atomicWeight: Double
    let category: String
    let fact: String
    let wikipediaLink: String
    let applications: [String]
    let roomTempState: String
    let history: String
    let examples: [[String: String]]
    let icon: String
    
    // New properties
    let meltingPoint: String?
    let boilingPoint: String?
    let electronegativity: Double?
    let discoveryYear: Int?
    let discoveredBy: String?
    let funFacts: [String]?
    let compounds: [ElementCompound]?
    let culturalReferences: [String]?
    let sustainabilityNotes: String?

    // Add computed properties for quiz games
    var number: Int { atomicNumber }  // Alias for compatibility with quiz games
    
    // Properties for periodic table location game
    var group: Int {
        return position.x
    }
    
    var period: Int {
        return position.y
    }
    
    // Position in the periodic table
    var position: (x: Int, y: Int) {
        return elementPositions[symbol] ?? (x: 1, y: 1) // Default position if not found
    }
    
    var electronConfiguration: String {
        // Check if we have a predefined configuration
        if let config = electronConfigurations[symbol] {
            return config
        }
        
        // Otherwise calculate it based on standard filling order
        return calculateElectronConfiguration(atomicNumber: atomicNumber)
    }
    
    // Add this computed property to your Element struct in Element.swift
    var formattedElectronConfiguration: [String] {
        // Get the full electron configuration string
        let fullConfig = electronConfiguration
        
        // Split by spaces
        let components = fullConfig.split(separator: " ")
        
        // Group by principal quantum number (shell)
        var shellGroups: [Int: [String]] = [:]
        
        for component in components {
            if let firstChar = component.first, let shellNumber = Int(String(firstChar)) {
                if shellGroups[shellNumber] == nil {
                    shellGroups[shellNumber] = []
                }
                shellGroups[shellNumber]?.append(String(component))
            }
        }
        
        // Create formatted array with one line per shell
        var result: [String] = []
        
        // Sort shells by number
        let sortedShells = shellGroups.keys.sorted()
        for shellNumber in sortedShells {
            if let orbitalGroup = shellGroups[shellNumber] {
                result.append(orbitalGroup.joined(separator: " "))
            }
        }
        
        return result
    }

    // Fix the calculation function to ensure correct configurations
    private func calculateElectronConfiguration(atomicNumber: Int) -> String {
        // Orbital filling order following Aufbau principle
        let orbitalOrder = ["1s", "2s", "2p", "3s", "3p", "4s", "3d", "4p", "5s", "4d", "5p", "6s", "4f", "5d", "6p", "7s", "5f", "6d", "7p"]
        let maxElectrons = [2, 2, 6, 2, 6, 2, 10, 6, 2, 10, 6, 2, 14, 10, 6, 2, 14, 10, 6]
        
        // Special cases are handled in the electronConfiguration property
        
        var remainingElectrons = atomicNumber
        var configuration = ""
        
        for (index, orbital) in orbitalOrder.enumerated() {
            if remainingElectrons <= 0 {
                break
            }
            
            let max = maxElectrons[index]
            let electrons = min(remainingElectrons, max)
            
            if electrons > 0 {
                if !configuration.isEmpty {
                    configuration += " "
                }
                
                // Use superscript characters for electron numbers
                let superscriptDigits = ["⁰", "¹", "²", "³", "⁴", "⁵", "⁶", "⁷", "⁸", "⁹"]
                var electronString = ""
                
                let electronDigits = String(electrons)
                for digit in electronDigits {
                    if let digitValue = Int(String(digit)), digitValue >= 0 && digitValue <= 9 {
                        electronString += superscriptDigits[digitValue]
                    }
                }
                
                configuration += "\(orbital)\(electronString)"
            }
            
            remainingElectrons -= electrons
        }
        
        return configuration
    }
    
    // The appropriate SF Symbol for each element category
    var categoryIcon: String {
        switch category {
        case "Nonmetal": return "wind"
        case "Noble Gas": return "bubble.right.fill"
        case "Alkali Metal": return "bolt.fill"
        case "Alkaline Earth Metal": return "square.grid.2x2.fill"
        case "Transition Metal": return "gear"
        case "Post-Transition Metal": return "cube.fill"
        case "Metalloid": return "diamond.fill"
        case "Halogen": return "drop.fill"
        case "Lanthanide": return "sparkles"
        case "Actinide": return "rays"
        default: return icon
        }
    }
    
    // Backward compatibility for the examples
    var images: [ElementImage]? {
        // Convert examples to the new ElementImage format if available
        if !examples.isEmpty {
            return examples.map { example in
                return ElementImage(
                    name: example["image"] ?? "",
                    description: example["description"] ?? ""
                )
            }
        }
        return nil
    }
    
    private enum CodingKeys: String, CodingKey {
        case name, symbol, atomicNumber, atomicWeight, category, fact
        case wikipediaLink, applications, roomTempState, history, examples, icon
        case meltingPoint, boilingPoint, electronegativity, discoveryYear, discoveredBy
        case funFacts, compounds, culturalReferences, sustainabilityNotes
    }
}

// New support structures
struct ElementCompound: Codable, Hashable {
    let name: String
    let description: String
}

struct ElementImage: Hashable {
    let name: String
    let description: String
}

// Position mapping
let elementPositions: [String: (x: Int, y: Int)] = [
    // Period 1
    "H": (1, 1),   // Hydrogen
    "He": (18, 1), // Helium

    // Period 2
    "Li": (1, 2),  // Lithium
    "Be": (2, 2),  // Beryllium
    "B": (13, 2),  // Boron
    "C": (14, 2),  // Carbon
    "N": (15, 2),  // Nitrogen
    "O": (16, 2),  // Oxygen
    "F": (17, 2),  // Fluorine
    "Ne": (18, 2), // Neon

    // Period 3
    "Na": (1, 3),  // Sodium
    "Mg": (2, 3),  // Magnesium
    "Al": (13, 3), // Aluminum
    "Si": (14, 3), // Silicon
    "P": (15, 3),  // Phosphorus
    "S": (16, 3),  // Sulfur
    "Cl": (17, 3), // Chlorine
    "Ar": (18, 3), // Argon

    // Period 4
    "K": (1, 4),   // Potassium
    "Ca": (2, 4),  // Calcium
    "Sc": (3, 4),  // Scandium
    "Ti": (4, 4),  // Titanium
    "V": (5, 4),   // Vanadium
    "Cr": (6, 4),  // Chromium
    "Mn": (7, 4),  // Manganese
    "Fe": (8, 4),  // Iron
    "Co": (9, 4),  // Cobalt
    "Ni": (10, 4), // Nickel
    "Cu": (11, 4), // Copper
    "Zn": (12, 4), // Zinc
    "Ga": (13, 4), // Gallium
    "Ge": (14, 4), // Germanium
    "As": (15, 4), // Arsenic
    "Se": (16, 4), // Selenium
    "Br": (17, 4), // Bromine
    "Kr": (18, 4), // Krypton

    // Period 5
    "Rb": (1, 5),  // Rubidium
    "Sr": (2, 5),  // Strontium
    "Y": (3, 5),   // Yttrium
    "Zr": (4, 5),  // Zirconium
    "Nb": (5, 5),  // Niobium
    "Mo": (6, 5),  // Molybdenum
    "Tc": (7, 5),  // Technetium
    "Ru": (8, 5),  // Ruthenium
    "Rh": (9, 5),  // Rhodium
    "Pd": (10, 5), // Palladium
    "Ag": (11, 5), // Silver
    "Cd": (12, 5), // Cadmium
    "In": (13, 5), // Indium
    "Sn": (14, 5), // Tin
    "Sb": (15, 5), // Antimony
    "Te": (16, 5), // Tellurium
    "I": (17, 5),  // Iodine
    "Xe": (18, 5), // Xenon

    // Period 6
    "Cs": (1, 6),  // Cesium
    "Ba": (2, 6),  // Barium
    "La": (3, 6),  // Lanthanum
    "Ce": (4, 9),  // Cerium (Lanthanides)
    "Pr": (5, 9),  // Praseodymium
    "Nd": (6, 9),  // Neodymium
    "Pm": (7, 9),  // Promethium
    "Sm": (8, 9),  // Samarium
    "Eu": (9, 9),  // Europium
    "Gd": (10, 9), // Gadolinium
    "Tb": (11, 9), // Terbium
    "Dy": (12, 9), // Dysprosium
    "Ho": (13, 9), // Holmium
    "Er": (14, 9), // Erbium
    "Tm": (15, 9), // Thulium
    "Yb": (16, 9), // Ytterbium
    "Lu": (17, 9), // Lutetium
    "Hf": (4, 6),  // Hafnium
    "Ta": (5, 6),  // Tantalum
    "W": (6, 6),   // Tungsten
    "Re": (7, 6),  // Rhenium
    "Os": (8, 6),  // Osmium
    "Ir": (9, 6),  // Iridium
    "Pt": (10, 6), // Platinum
    "Au": (11, 6), // Gold
    "Hg": (12, 6), // Mercury
    "Tl": (13, 6), // Thallium
    "Pb": (14, 6), // Lead
    "Bi": (15, 6), // Bismuth
    "Po": (16, 6), // Polonium
    "At": (17, 6), // Astatine
    "Rn": (18, 6), // Radon

    // Period 7
    "Fr": (1, 7),  // Francium
    "Ra": (2, 7),  // Radium
    "Ac": (3, 7),  // Actinium
    "Th": (4, 10), // Thorium (Actinides)
    "Pa": (5, 10), // Protactinium
    "U": (6, 10),  // Uranium
    "Np": (7, 10), // Neptunium
    "Pu": (8, 10), // Plutonium
    "Am": (9, 10), // Americium
    "Cm": (10, 10), // Curium
    "Bk": (11, 10), // Berkelium
    "Cf": (12, 10), // Californium
    "Es": (13, 10), // Einsteinium
    "Fm": (14, 10), // Fermium
    "Md": (15, 10), // Mendelevium
    "No": (16, 10), // Nobelium
    "Lr": (17, 10), // Lawrencium
    "Rf": (4, 7),  // Rutherfordium
    "Db": (5, 7),  // Dubnium
    "Sg": (6, 7),  // Seaborgium
    "Bh": (7, 7),  // Bohrium
    "Hs": (8, 7),  // Hassium
    "Mt": (9, 7),  // Meitnerium
    "Ds": (10, 7), // Darmstadtium
    "Rg": (11, 7), // Roentgenium
    "Cn": (12, 7), // Copernicium
    "Nh": (13, 7), // Nihonium
    "Fl": (14, 7), // Flerovium
    "Mc": (15, 7), // Moscovium
    "Lv": (16, 7), // Livermorium
    "Ts": (17, 7), // Tennessine
    "Og": (18, 7), // Oganesson
]

// Complete electron configurations dictionary covering all elements
let electronConfigurations: [String: String] = [
    // Period 1
    "H": "1s¹",
    "He": "1s²",
    
    // Period 2
    "Li": "1s² 2s¹",
    "Be": "1s² 2s²",
    "B": "1s² 2s² 2p¹",
    "C": "1s² 2s² 2p²",
    "N": "1s² 2s² 2p³",
    "O": "1s² 2s² 2p⁴",
    "F": "1s² 2s² 2p⁵",
    "Ne": "1s² 2s² 2p⁶",
    
    // Period 3
    "Na": "1s² 2s² 2p⁶ 3s¹",
    "Mg": "1s² 2s² 2p⁶ 3s²",
    "Al": "1s² 2s² 2p⁶ 3s² 3p¹",
    "Si": "1s² 2s² 2p⁶ 3s² 3p²",
    "P": "1s² 2s² 2p⁶ 3s² 3p³",
    "S": "1s² 2s² 2p⁶ 3s² 3p⁴",
    "Cl": "1s² 2s² 2p⁶ 3s² 3p⁵",
    "Ar": "1s² 2s² 2p⁶ 3s² 3p⁶",
    
    // Period 4
    "K": "1s² 2s² 2p⁶ 3s² 3p⁶ 4s¹",
    "Ca": "1s² 2s² 2p⁶ 3s² 3p⁶ 4s²",
    "Sc": "1s² 2s² 2p⁶ 3s² 3p⁶ 3d¹ 4s²",
    "Ti": "1s² 2s² 2p⁶ 3s² 3p⁶ 3d² 4s²",
    "V": "1s² 2s² 2p⁶ 3s² 3p⁶ 3d³ 4s²",
    "Cr": "1s² 2s² 2p⁶ 3s² 3p⁶ 3d⁵ 4s¹", // Exception to rule
    "Mn": "1s² 2s² 2p⁶ 3s² 3p⁶ 3d⁵ 4s²",
    "Fe": "1s² 2s² 2p⁶ 3s² 3p⁶ 3d⁶ 4s²",
    "Co": "1s² 2s² 2p⁶ 3s² 3p⁶ 3d⁷ 4s²",
    "Ni": "1s² 2s² 2p⁶ 3s² 3p⁶ 3d⁸ 4s²",
    "Cu": "1s² 2s² 2p⁶ 3s² 3p⁶ 3d¹⁰ 4s¹", // Exception to rule
    "Zn": "1s² 2s² 2p⁶ 3s² 3p⁶ 3d¹⁰ 4s²",
    "Ga": "1s² 2s² 2p⁶ 3s² 3p⁶ 3d¹⁰ 4s² 4p¹",
    "Ge": "1s² 2s² 2p⁶ 3s² 3p⁶ 3d¹⁰ 4s² 4p²",
    "As": "1s² 2s² 2p⁶ 3s² 3p⁶ 3d¹⁰ 4s² 4p³",
    "Se": "1s² 2s² 2p⁶ 3s² 3p⁶ 3d¹⁰ 4s² 4p⁴",
    "Br": "1s² 2s² 2p⁶ 3s² 3p⁶ 3d¹⁰ 4s² 4p⁵",
    "Kr": "1s² 2s² 2p⁶ 3s² 3p⁶ 3d¹⁰ 4s² 4p⁶",
    
    // Period 5
    "Rb": "1s² 2s² 2p⁶ 3s² 3p⁶ 3d¹⁰ 4s² 4p⁶ 5s¹",
    "Sr": "1s² 2s² 2p⁶ 3s² 3p⁶ 3d¹⁰ 4s² 4p⁶ 5s²",
    "Y": "1s² 2s² 2p⁶ 3s² 3p⁶ 3d¹⁰ 4s² 4p⁶ 4d¹ 5s²",
    "Zr": "1s² 2s² 2p⁶ 3s² 3p⁶ 3d¹⁰ 4s² 4p⁶ 4d² 5s²",
    "Nb": "1s² 2s² 2p⁶ 3s² 3p⁶ 3d¹⁰ 4s² 4p⁶ 4d⁴ 5s¹", // Exception
    "Mo": "1s² 2s² 2p⁶ 3s² 3p⁶ 3d¹⁰ 4s² 4p⁶ 4d⁵ 5s¹", // Exception
    "Tc": "1s² 2s² 2p⁶ 3s² 3p⁶ 3d¹⁰ 4s² 4p⁶ 4d⁵ 5s²",
    "Ru": "1s² 2s² 2p⁶ 3s² 3p⁶ 3d¹⁰ 4s² 4p⁶ 4d⁷ 5s¹", // Exception
    "Rh": "1s² 2s² 2p⁶ 3s² 3p⁶ 3d¹⁰ 4s² 4p⁶ 4d⁸ 5s¹", // Exception
    "Pd": "1s² 2s² 2p⁶ 3s² 3p⁶ 3d¹⁰ 4s² 4p⁶ 4d¹⁰", // Exception
    "Ag": "1s² 2s² 2p⁶ 3s² 3p⁶ 3d¹⁰ 4s² 4p⁶ 4d¹⁰ 5s¹",
    "Cd": "1s² 2s² 2p⁶ 3s² 3p⁶ 3d¹⁰ 4s² 4p⁶ 4d¹⁰ 5s²",
    "In": "1s² 2s² 2p⁶ 3s² 3p⁶ 3d¹⁰ 4s² 4p⁶ 4d¹⁰ 5s² 5p¹",
    "Sn": "1s² 2s² 2p⁶ 3s² 3p⁶ 3d¹⁰ 4s² 4p⁶ 4d¹⁰ 5s² 5p²",
    "Sb": "1s² 2s² 2p⁶ 3s² 3p⁶ 3d¹⁰ 4s² 4p⁶ 4d¹⁰ 5s² 5p³",
    "Te": "1s² 2s² 2p⁶ 3s² 3p⁶ 3d¹⁰ 4s² 4p⁶ 4d¹⁰ 5s² 5p⁴",
    "I": "1s² 2s² 2p⁶ 3s² 3p⁶ 3d¹⁰ 4s² 4p⁶ 4d¹⁰ 5s² 5p⁵",
    "Xe": "1s² 2s² 2p⁶ 3s² 3p⁶ 3d¹⁰ 4s² 4p⁶ 4d¹⁰ 5s² 5p⁶",
    
    // Period 6 - Complete
    "Cs": "1s² 2s² 2p⁶ 3s² 3p⁶ 3d¹⁰ 4s² 4p⁶ 4d¹⁰ 5s² 5p⁶ 6s¹",
    "Ba": "1s² 2s² 2p⁶ 3s² 3p⁶ 3d¹⁰ 4s² 4p⁶ 4d¹⁰ 5s² 5p⁶ 6s²",
    "La": "1s² 2s² 2p⁶ 3s² 3p⁶ 3d¹⁰ 4s² 4p⁶ 4d¹⁰ 5s² 5p⁶ 5d¹ 6s²",
    "Ce": "1s² 2s² 2p⁶ 3s² 3p⁶ 3d¹⁰ 4s² 4p⁶ 4d¹⁰ 5s² 5p⁶ 4f¹ 5d¹ 6s²",
    "Pr": "1s² 2s² 2p⁶ 3s² 3p⁶ 3d¹⁰ 4s² 4p⁶ 4d¹⁰ 5s² 5p⁶ 4f³ 6s²",
    "Nd": "1s² 2s² 2p⁶ 3s² 3p⁶ 3d¹⁰ 4s² 4p⁶ 4d¹⁰ 5s² 5p⁶ 4f⁴ 6s²",
    "Pm": "1s² 2s² 2p⁶ 3s² 3p⁶ 3d¹⁰ 4s² 4p⁶ 4d¹⁰ 5s² 5p⁶ 4f⁵ 6s²",
    "Sm": "1s² 2s² 2p⁶ 3s² 3p⁶ 3d¹⁰ 4s² 4p⁶ 4d¹⁰ 5s² 5p⁶ 4f⁶ 6s²",
    "Eu": "1s² 2s² 2p⁶ 3s² 3p⁶ 3d¹⁰ 4s² 4p⁶ 4d¹⁰ 5s² 5p⁶ 4f⁷ 6s²",
    "Gd": "1s² 2s² 2p⁶ 3s² 3p⁶ 3d¹⁰ 4s² 4p⁶ 4d¹⁰ 5s² 5p⁶ 4f⁷ 5d¹ 6s²",
    "Tb": "1s² 2s² 2p⁶ 3s² 3p⁶ 3d¹⁰ 4s² 4p⁶ 4d¹⁰ 5s² 5p⁶ 4f⁹ 6s²",
    "Dy": "1s² 2s² 2p⁶ 3s² 3p⁶ 3d¹⁰ 4s² 4p⁶ 4d¹⁰ 5s² 5p⁶ 4f¹⁰ 6s²",
    "Ho": "1s² 2s² 2p⁶ 3s² 3p⁶ 3d¹⁰ 4s² 4p⁶ 4d¹⁰ 5s² 5p⁶ 4f¹¹ 6s²",
    "Er": "1s² 2s² 2p⁶ 3s² 3p⁶ 3d¹⁰ 4s² 4p⁶ 4d¹⁰ 5s² 5p⁶ 4f¹² 6s²",
    "Tm": "1s² 2s² 2p⁶ 3s² 3p⁶ 3d¹⁰ 4s² 4p⁶ 4d¹⁰ 5s² 5p⁶ 4f¹³ 6s²",
    "Yb": "1s² 2s² 2p⁶ 3s² 3p⁶ 3d¹⁰ 4s² 4p⁶ 4d¹⁰ 5s² 5p⁶ 4f¹⁴ 6s²",
    "Lu": "1s² 2s² 2p⁶ 3s² 3p⁶ 3d¹⁰ 4s² 4p⁶ 4d¹⁰ 5s² 5p⁶ 4f¹⁴ 5d¹ 6s²",
    "Hf": "1s² 2s² 2p⁶ 3s² 3p⁶ 3d¹⁰ 4s² 4p⁶ 4d¹⁰ 4f¹⁴ 5s² 5p⁶ 5d² 6s²",
    "Ta": "1s² 2s² 2p⁶ 3s² 3p⁶ 3d¹⁰ 4s² 4p⁶ 4d¹⁰ 4f¹⁴ 5s² 5p⁶ 5d³ 6s²",
    "W": "1s² 2s² 2p⁶ 3s² 3p⁶ 3d¹⁰ 4s² 4p⁶ 4d¹⁰ 4f¹⁴ 5s² 5p⁶ 5d⁴ 6s²",
    "Re": "1s² 2s² 2p⁶ 3s² 3p⁶ 3d¹⁰ 4s² 4p⁶ 4d¹⁰ 4f¹⁴ 5s² 5p⁶ 5d⁵ 6s²",
    "Os": "1s² 2s² 2p⁶ 3s² 3p⁶ 3d¹⁰ 4s² 4p⁶ 4d¹⁰ 4f¹⁴ 5s² 5p⁶ 5d⁶ 6s²",
    "Ir": "1s² 2s² 2p⁶ 3s² 3p⁶ 3d¹⁰ 4s² 4p⁶ 4d¹⁰ 4f¹⁴ 5s² 5p⁶ 5d⁷ 6s²",
    "Pt": "1s² 2s² 2p⁶ 3s² 3p⁶ 3d¹⁰ 4s² 4p⁶ 4d¹⁰ 4f¹⁴ 5s² 5p⁶ 5d⁹ 6s¹",
    "Au": "1s² 2s² 2p⁶ 3s² 3p⁶ 3d¹⁰ 4s² 4p⁶ 4d¹⁰ 4f¹⁴ 5s² 5p⁶ 5d¹⁰ 6s¹",
    "Hg": "1s² 2s² 2p⁶ 3s² 3p⁶ 3d¹⁰ 4s² 4p⁶ 4d¹⁰ 4f¹⁴ 5s² 5p⁶ 5d¹⁰ 6s²",
    "Tl": "1s² 2s² 2p⁶ 3s² 3p⁶ 3d¹⁰ 4s² 4p⁶ 4d¹⁰ 4f¹⁴ 5s² 5p⁶ 5d¹⁰ 6s² 6p¹",
    "Pb": "1s² 2s² 2p⁶ 3s² 3p⁶ 3d¹⁰ 4s² 4p⁶ 4d¹⁰ 4f¹⁴ 5s² 5p⁶ 5d¹⁰ 6s² 6p²",
    "Bi": "1s² 2s² 2p⁶ 3s² 3p⁶ 3d¹⁰ 4s² 4p⁶ 4d¹⁰ 4f¹⁴ 5s² 5p⁶ 5d¹⁰ 6s² 6p³",
    "Po": "1s² 2s² 2p⁶ 3s² 3p⁶ 3d¹⁰ 4s² 4p⁶ 4d¹⁰ 4f¹⁴ 5s² 5p⁶ 5d¹⁰ 6s² 6p⁴",
    "At": "1s² 2s² 2p⁶ 3s² 3p⁶ 3d¹⁰ 4s² 4p⁶ 4d¹⁰ 4f¹⁴ 5s² 5p⁶ 5d¹⁰ 6s² 6p⁵",
    "Rn": "1s² 2s² 2p⁶ 3s² 3p⁶ 3d¹⁰ 4s² 4p⁶ 4d¹⁰ 4f¹⁴ 5s² 5p⁶ 5d¹⁰ 6s² 6p⁶",
    
    // Period 7 - Complete
    "Fr": "1s² 2s² 2p⁶ 3s² 3p⁶ 3d¹⁰ 4s² 4p⁶ 4d¹⁰ 4f¹⁴ 5s² 5p⁶ 5d¹⁰ 6s² 6p⁶ 7s¹",
    "Ra": "1s² 2s² 2p⁶ 3s² 3p⁶ 3d¹⁰ 4s² 4p⁶ 4d¹⁰ 4f¹⁴ 5s² 5p⁶ 5d¹⁰ 6s² 6p⁶ 7s²",
    "Ac": "1s² 2s² 2p⁶ 3s² 3p⁶ 3d¹⁰ 4s² 4p⁶ 4d¹⁰ 4f¹⁴ 5s² 5p⁶ 5d¹⁰ 6s² 6p⁶ 6d¹ 7s²",
    "Th": "1s² 2s² 2p⁶ 3s² 3p⁶ 3d¹⁰ 4s² 4p⁶ 4d¹⁰ 4f¹⁴ 5s² 5p⁶ 5d¹⁰ 6s² 6p⁶ 6d² 7s²",
    "Pa": "1s² 2s² 2p⁶ 3s² 3p⁶ 3d¹⁰ 4s² 4p⁶ 4d¹⁰ 4f¹⁴ 5s² 5p⁶ 5d¹⁰ 6s² 6p⁶ 5f² 6d¹ 7s²",
    "U": "1s² 2s² 2p⁶ 3s² 3p⁶ 3d¹⁰ 4s² 4p⁶ 4d¹⁰ 4f¹⁴ 5s² 5p⁶ 5d¹⁰ 6s² 6p⁶ 5f³ 6d¹ 7s²",
    "Np": "1s² 2s² 2p⁶ 3s² 3p⁶ 3d¹⁰ 4s² 4p⁶ 4d¹⁰ 4f¹⁴ 5s² 5p⁶ 5d¹⁰ 6s² 6p⁶ 5f⁴ 6d¹ 7s²",
    "Pu": "1s² 2s² 2p⁶ 3s² 3p⁶ 3d¹⁰ 4s² 4p⁶ 4d¹⁰ 4f¹⁴ 5s² 5p⁶ 5d¹⁰ 6s² 6p⁶ 5f⁶ 7s²",
    "Am": "1s² 2s² 2p⁶ 3s² 3p⁶ 3d¹⁰ 4s² 4p⁶ 4d¹⁰ 4f¹⁴ 5s² 5p⁶ 5d¹⁰ 6s² 6p⁶ 5f⁷ 7s²",
    "Cm": "1s² 2s² 2p⁶ 3s² 3p⁶ 3d¹⁰ 4s² 4p⁶ 4d¹⁰ 4f¹⁴ 5s² 5p⁶ 5d¹⁰ 6s² 6p⁶ 5f⁷ 6d¹ 7s²",
    "Bk": "1s² 2s² 2p⁶ 3s² 3p⁶ 3d¹⁰ 4s² 4p⁶ 4d¹⁰ 4f¹⁴ 5s² 5p⁶ 5d¹⁰ 6s² 6p⁶ 5f⁹ 7s²",
    "Cf": "1s² 2s² 2p⁶ 3s² 3p⁶ 3d¹⁰ 4s² 4p⁶ 4d¹⁰ 4f¹⁴ 5s² 5p⁶ 5d¹⁰ 6s² 6p⁶ 5f¹⁰ 7s²",
    "Es": "1s² 2s² 2p⁶ 3s² 3p⁶ 3d¹⁰ 4s² 4p⁶ 4d¹⁰ 4f¹⁴ 5s² 5p⁶ 5d¹⁰ 6s² 6p⁶ 5f¹¹ 7s²",
    "Fm": "1s² 2s² 2p⁶ 3s² 3p⁶ 3d¹⁰ 4s² 4p⁶ 4d¹⁰ 4f¹⁴ 5s² 5p⁶ 5d¹⁰ 6s² 6p⁶ 5f¹² 7s²",
    "Md": "1s² 2s² 2p⁶ 3s² 3p⁶ 3d¹⁰ 4s² 4p⁶ 4d¹⁰ 4f¹⁴ 5s² 5p⁶ 5d¹⁰ 6s² 6p⁶ 5f¹³ 7s²",
    "No": "1s² 2s² 2p⁶ 3s² 3p⁶ 3d¹⁰ 4s² 4p⁶ 4d¹⁰ 4f¹⁴ 5s² 5p⁶ 5d¹⁰ 6s² 6p⁶ 5f¹⁴ 7s²",
    "Lr": "1s² 2s² 2p⁶ 3s² 3p⁶ 3d¹⁰ 4s² 4p⁶ 4d¹⁰ 4f¹⁴ 5s² 5p⁶ 5d¹⁰ 6s² 6p⁶ 5f¹⁴ 7s² 7p¹",
    "Rf": "1s² 2s² 2p⁶ 3s² 3p⁶ 3d¹⁰ 4s² 4p⁶ 4d¹⁰ 4f¹⁴ 5s² 5p⁶ 5d¹⁰ 6s² 6p⁶ 5f¹⁴ 6d² 7s²",
    "Db": "1s² 2s² 2p⁶ 3s² 3p⁶ 3d¹⁰ 4s² 4p⁶ 4d¹⁰ 4f¹⁴ 5s² 5p⁶ 5d¹⁰ 6s² 6p⁶ 5f¹⁴ 6d³ 7s²",
    "Sg": "1s² 2s² 2p⁶ 3s² 3p⁶ 3d¹⁰ 4s² 4p⁶ 4d¹⁰ 4f¹⁴ 5s² 5p⁶ 5d¹⁰ 6s² 6p⁶ 5f¹⁴ 6d⁴ 7s²",
    "Bh": "1s² 2s² 2p⁶ 3s² 3p⁶ 3d¹⁰ 4s² 4p⁶ 4d¹⁰ 4f¹⁴ 5s² 5p⁶ 5d¹⁰ 6s² 6p⁶ 5f¹⁴ 6d⁵ 7s²",
    "Hs": "1s² 2s² 2p⁶ 3s² 3p⁶ 3d¹⁰ 4s² 4p⁶ 4d¹⁰ 4f¹⁴ 5s² 5p⁶ 5d¹⁰ 6s² 6p⁶ 5f¹⁴ 6d⁶ 7s²",
    "Mt": "1s² 2s² 2p⁶ 3s² 3p⁶ 3d¹⁰ 4s² 4p⁶ 4d¹⁰ 4f¹⁴ 5s² 5p⁶ 5d¹⁰ 6s² 6p⁶ 5f¹⁴ 6d⁷ 7s²",
    "Ds": "1s² 2s² 2p⁶ 3s² 3p⁶ 3d¹⁰ 4s² 4p⁶ 4d¹⁰ 4f¹⁴ 5s² 5p⁶ 5d¹⁰ 6s² 6p⁶ 5f¹⁴ 6d⁸ 7s²",
    "Rg": "1s² 2s² 2p⁶ 3s² 3p⁶ 3d¹⁰ 4s² 4p⁶ 4d¹⁰ 4f¹⁴ 5s² 5p⁶ 5d¹⁰ 6s² 6p⁶ 5f¹⁴ 6d⁹ 7s²",
    "Cn": "1s² 2s² 2p⁶ 3s² 3p⁶ 3d¹⁰ 4s² 4p⁶ 4d¹⁰ 4f¹⁴ 5s² 5p⁶ 5d¹⁰ 6s² 6p⁶ 5f¹⁴ 6d¹⁰ 7s²",
    "Nh": "1s² 2s² 2p⁶ 3s² 3p⁶ 3d¹⁰ 4s² 4p⁶ 4d¹⁰ 4f¹⁴ 5s² 5p⁶ 5d¹⁰ 6s² 6p⁶ 5f¹⁴ 6d¹⁰ 7s² 7p¹",
    "Fl": "1s² 2s² 2p⁶ 3s² 3p⁶ 3d¹⁰ 4s² 4p⁶ 4d¹⁰ 4f¹⁴ 5s² 5p⁶ 5d¹⁰ 6s² 6p⁶ 5f¹⁴ 6d¹⁰ 7s² 7p²",
    "Mc": "1s² 2s² 2p⁶ 3s² 3p⁶ 3d¹⁰ 4s² 4p⁶ 4d¹⁰ 4f¹⁴ 5s² 5p⁶ 5d¹⁰ 6s² 6p⁶ 5f¹⁴ 6d¹⁰ 7s² 7p³",
    "Lv": "1s² 2s² 2p⁶ 3s² 3p⁶ 3d¹⁰ 4s² 4p⁶ 4d¹⁰ 4f¹⁴ 5s² 5p⁶ 5d¹⁰ 6s² 6p⁶ 5f¹⁴ 6d¹⁰ 7s² 7p⁴",
    "Ts": "1s² 2s² 2p⁶ 3s² 3p⁶ 3d¹⁰ 4s² 4p⁶ 4d¹⁰ 4f¹⁴ 5s² 5p⁶ 5d¹⁰ 6s² 6p⁶ 5f¹⁴ 6d¹⁰ 7s² 7p⁵",
    "Og": "1s² 2s² 2p⁶ 3s² 3p⁶ 3d¹⁰ 4s² 4p⁶ 4d¹⁰ 4f¹⁴ 5s² 5p⁶ 5d¹⁰ 6s² 6p⁶ 5f¹⁴ 6d¹⁰ 7s² 7p⁶"
]
