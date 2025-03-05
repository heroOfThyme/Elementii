//
//  ElementTile.swift
//  Elementii
//
//  Created by Petar Vidakovic on 2025-03-01.
//


import SwiftUI

struct ElementTile: View {
    let element: Element
    
    var body: some View {
        VStack {
            Spacer()
            
            Text(String(element.atomicNumber))
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.white)
            
            Spacer()
            
            Text(element.symbol)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)
                .lineLimit(1)
            
            Spacer()
            
            Text(element.name)
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(.white)
                .lineLimit(2)
                .multilineTextAlignment(.center)
            
            Spacer()
        }
        .frame(width: 78, height: 94)
        .background(Color(element.categoryColor))
        .cornerRadius(10)
    }
}
