//
//  ElementListView.swift
//  Elementii
//
//  Created by Petar Vidakovic on 2025-03-01.
//

import SwiftUI

struct ElementListView: View {
    let elements: [Element] = Bundle.main.decode("elements.json")
    
    var body: some View {
        List(elements) { element in
            NavigationLink(destination: ElementDetailView(element: element)) {
                HStack {
                    Text(element.symbol)
                        .font(.title)
                        .frame(width: 50, alignment: .center)
                    VStack(alignment: .leading) {
                        Text(element.name)
                            .font(.headline)
                        Text("Atomic Number: \(element.atomicNumber)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
            }
            .listRowBackground(Color.black.opacity(0.01))
        }
        .navigationTitle("Elements")
    }
}
