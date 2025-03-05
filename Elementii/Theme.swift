//
//  Theme.swift
//  Elementii
//
//  Created by Petar Vidakovic on 2025-03-04.
//


import SwiftUI

struct Theme {
    @Environment(\.colorScheme) static var colorScheme
    
    static let background = Color("Background")
    static let text = Color("Text")
    static let primary = Color("AppPrimary") // Updated
    static let secondary = Color("AppSecondary") // Updated
    static let accent = Color("AccentColor") // Updated
    
    static let tableAccent = Color("TableAccent")
    
}
