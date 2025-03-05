//
//  WrappingHStack.swift
//  Elementii
//
//  Created by Petar Vidakovic on 2025-03-04.
//

import SwiftUI

struct WrappingHStack: Layout {
    var horizontalSpacing: CGFloat
    var verticalSpacing: CGFloat
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let sizes = subviews.map { $0.sizeThatFits(.unspecified) }
        
        var totalHeight: CGFloat = 0
        var currentWidth: CGFloat = 0
        var currentRowHeight: CGFloat = 0
        
        for size in sizes {
            if currentWidth + size.width > proposal.width ?? .infinity {
                // Move to the next row
                totalHeight += currentRowHeight + verticalSpacing
                currentWidth = size.width
                currentRowHeight = size.height
            } else {
                // Add to the current row
                if currentWidth > 0 {
                    currentWidth += horizontalSpacing
                }
                currentWidth += size.width
                currentRowHeight = max(currentRowHeight, size.height)
            }
        }
        
        // Add the last row's height
        totalHeight += currentRowHeight
        
        return CGSize(width: proposal.width ?? .infinity, height: totalHeight)
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var x = bounds.minX
        var y = bounds.minY
        var currentRowHeight: CGFloat = 0
        
        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            
            if x + size.width > bounds.maxX {
                // Move to the next row
                x = bounds.minX
                y += currentRowHeight + verticalSpacing
                currentRowHeight = 0
            }
            
            subview.place(at: CGPoint(x: x, y: y), anchor: .topLeading, proposal: .unspecified)
            x += size.width + horizontalSpacing
            currentRowHeight = max(currentRowHeight, size.height)
        }
    }
}
