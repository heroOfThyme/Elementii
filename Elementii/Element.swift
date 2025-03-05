//
//  Element.swift
//  Elementii
//
//  Created by Petar Vidakovic on 2025-02-25.
//


import Foundation

// Load the JSON data
import Foundation

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

    // Position in the periodic table
    var position: (x: Int, y: Int) {
        return elementPositions[symbol] ?? (x: 1, y: 1) // Default position if not found
    }
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
