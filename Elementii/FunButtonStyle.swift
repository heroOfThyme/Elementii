//
//  FunButtonStyle.swift
//  Elementii
//
//  Created by Petar Vidakovic on 2025-03-04.
//

import SwiftUI

struct FunButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .padding()
            .background(Theme.accent)
            .foregroundColor(Theme.text)
            .cornerRadius(15)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}
