//
//  PeriodicTableTileType.swift
//  Elementii
//
//  Created by Petar Vidakovic on 2025-03-05.
//

import SwiftUI

enum PeriodicTableTileType {
    case empty
    case numberRange(text: String, color: Color)
    case element(element: Element)
    
    static func type(for tile: (group: Int, row: Int), elements: [Element]) -> Self {
        // Lanthanides (Row 8) and Actinides (Row 9)
        if tile.row == 8 && tile.group == 3 {
            return .numberRange(text: "57-71", color: Color("Lanthanide"))
        }
        if tile.row == 9 && tile.group == 3 {
            return .numberRange(text: "89-103", color: Color("Actinide"))
        }
        
        // Empty spaces
        if (tile.row == 1 && (2...17).contains(tile.group)) ||
            ((2...3).contains(tile.row) && (3...12).contains(tile.group)) {
            return .empty
        }
        
        // Find element
        if let element = elements.first(where: { $0.position.x == tile.group && $0.position.y == tile.row }) {
            return .element(element: element)
        }
        
        return .empty
    }
}
