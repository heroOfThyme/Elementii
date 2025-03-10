//
//  ElementDataStore.swift
//  Elementii
//
//  Created by Petar Vidakovic on 2025-03-08.
//


import Foundation
import SwiftUI

class ElementDataStore: ObservableObject {
    static let shared = ElementDataStore()
    
    @Published var elements: [Element] = []
    private var nameIndex: [String: [Element]] = [:]
    private var symbolIndex: [String: [Element]] = [:]
    private var categoryIndex: [String: [Element]] = [:]
    
    private init() {
        loadData()
    }
    
    private func loadData() {
        // Load data in background
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            
            let loadedElements = Bundle.main.decode("elements.json") as [Element]
            let sortedElements = loadedElements.sorted { $0.atomicNumber < $1.atomicNumber }
            
            // Create search indices
            self.createSearchIndices(from: sortedElements)
            
            // Update on main thread
            DispatchQueue.main.async {
                self.elements = sortedElements
            }
        }
    }
    
    private func createSearchIndices(from elements: [Element]) {
        // Create lookup tables for common search fields
        for element in elements {
            // Index by name (with prefix searching)
            let name = element.name.lowercased()
            for length in 1...name.count {
                let prefix = String(name.prefix(length))
                if nameIndex[prefix] == nil {
                    nameIndex[prefix] = []
                }
                nameIndex[prefix]?.append(element)
            }
            
            // Index by symbol
            let symbol = element.symbol.lowercased()
            for length in 1...symbol.count {
                let prefix = String(symbol.prefix(length))
                if symbolIndex[prefix] == nil {
                    symbolIndex[prefix] = []
                }
                symbolIndex[prefix]?.append(element)
            }
            
            // Index by category
            let category = element.category.lowercased()
            if categoryIndex[category] == nil {
                categoryIndex[category] = []
            }
            categoryIndex[category]?.append(element)
        }
    }
    
    func searchElements(query: String) -> [Element] {
        if query.isEmpty {
            return elements
        }
        
        let searchText = query.lowercased()
        
        // Check if we can use our indices for faster lookup
        if let nameMatches = nameIndex[searchText] {
            return nameMatches
        }
        
        if let symbolMatches = symbolIndex[searchText] {
            return symbolMatches
        }
        
        if let categoryMatches = categoryIndex[searchText] {
            return categoryMatches
        }
        
        // Fall back to standard filtering if no exact prefix match
        return elements.filter { element in
            element.name.lowercased().contains(searchText) ||
            element.symbol.lowercased().contains(searchText) ||
            String(element.atomicNumber).contains(searchText) ||
            element.category.lowercased().contains(searchText)
        }
    }
}