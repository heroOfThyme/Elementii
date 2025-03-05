//
//  ElementCategoryColor.swift
//  Elementii
//
//  Created by Petar Vidakovic on 2025-02-26.
//

import SwiftUI

extension Element {
    // Computed property to map category to color
    var categoryColor: Color {
        switch category {
        case "Alkali Metal": return Color("Alkali Metal")
        case "Alkaline Earth Metal": return Color("Alkaline Earth Metal")
        case "Transition Metal": return Color("Transition Metal")
        case "Post-Transition Metal": return Color("Post-Transition Metal")
        case "Metalloid": return Color("Metalloid")
        case "Nonmetal": return Color("Nonmetal")
        case "Halogen": return Color("Halogen")
        case "Noble Gas": return Color("Noble Gas")
        case "Lanthanide": return Color("Lanthanide")
        case "Actinide": return Color("Actinide")
        default: return Color("Default") // Fallback color
        }
    }
}
