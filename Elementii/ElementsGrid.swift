//
//  ElementsGrid.swift
//  Elementii
//
//  Created by Petar Vidakovic on 2025-03-01.
//

import SwiftUI

struct ElementsGrid: View {
    let elements: [Element]
    
    var body: some View {
        ZStack {
            ForEach(elements) { element in
                NavigationLink(destination: ElementDetailView(element: element)) {
                    ElementTile(element: element)
                }
                .position(
                    x: CGFloat(element.position.x) * 85, // Adjusted spacing for larger tiles
                    y: CGFloat(element.position.y) * 85  // Adjusted spacing for larger tiles
                )
            }
        }
        .background(Theme.tableAccent)
    }
}
