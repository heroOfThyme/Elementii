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
                    elementTile(for: element)
                }
                .position(
                    x: CGFloat(element.position.x) * 85, // Adjusted spacing for larger tiles
                    y: CGFloat(element.position.y) * 85  // Adjusted spacing for larger tiles
                )
            }
        }
        .background(Theme.tableAccent)
    }
    
    // Element tile from your PeriodicGridView
    private func elementTile(for element: Element) -> some View {
        VStack(spacing: 1) {
            // Atomic number
            Text("\(element.atomicNumber)")
                .font(.system(size: 10))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .center)
            
            // Element symbol
            Text(element.symbol)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
                .frame(height: 26)
            
            // Element name
            Text(element.name)
                .font(.system(size: 9))
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                .foregroundColor(.white)
            
            // Atomic weight
            Text(String(format: "%.3f", element.atomicWeight))
                .font(.system(size: 9))
                .foregroundColor(.white.opacity(0.9))
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

#Preview {
    ElementsGrid(elements: Bundle.main.decode("elements.json"))
}
