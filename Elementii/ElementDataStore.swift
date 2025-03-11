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
    @Published var isLoading: Bool = true
    @Published var searchIndexesReady: Bool = false
    
    // Specialized data structures for instant search
    private var atomicNumberMap: [Int: Element] = [:]          // Fast exact number lookup
    private var symbolExactMap: [String: Element] = [:]        // Fast exact symbol lookup
    private var nameExactMap: [String: Element] = [:]          // Fast exact name lookup
    private var nameIndexes: [String: [Element]] = [:]         // Fast prefix search
    private var symbolIndexes: [String: [Element]] = [:]       // Fast prefix search
    private var categoryMap: [String: [Element]] = [:]         // Fast category lookup
    
    // Cache for search results
    private var searchCache: [String: [Element]] = [:]
    
    private init() {
        // Start immediate data loading and indexing
        loadData()
    }
    
    private func loadData() {
        // Indicate we're loading data
        isLoading = true
        
        // Load on a background thread to keep UI responsive
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            
            // 1. Load the basic element data first
            let loadedElements = Bundle.main.decode("elements.json") as [Element]
            let sortedElements = loadedElements.sorted { $0.atomicNumber < $1.atomicNumber }
            
            // 2. Update UI with basic data so the app can start displaying content
            DispatchQueue.main.async {
                self.elements = sortedElements
                self.isLoading = false
            }
            
            // 3. Now build all search indexes (this is the time-consuming part)
            for element in sortedElements {
                // Exact lookup maps
                self.atomicNumberMap[element.atomicNumber] = element
                self.symbolExactMap[element.symbol.lowercased()] = element
                self.nameExactMap[element.name.lowercased()] = element
                
                // Name prefix indexes
                let name = element.name.lowercased()
                for prefixLength in 1...name.count {
                    let prefix = String(name.prefix(prefixLength))
                    if self.nameIndexes[prefix] == nil {
                        self.nameIndexes[prefix] = []
                    }
                    self.nameIndexes[prefix]?.append(element)
                }
                
                // Symbol prefix indexes
                let symbol = element.symbol.lowercased()
                for prefixLength in 1...symbol.count {
                    let prefix = String(symbol.prefix(prefixLength))
                    if self.symbolIndexes[prefix] == nil {
                        self.symbolIndexes[prefix] = []
                    }
                    self.symbolIndexes[prefix]?.append(element)
                }
                
                // Category grouping
                let category = element.category.lowercased()
                if self.categoryMap[category] == nil {
                    self.categoryMap[category] = []
                }
                self.categoryMap[category]?.append(element)
            }
            
            // 4. Add some common search terms
            let commonSearches = ["metal", "gas", "liquid", "transition", "noble", "halogen", "radioactive"]
            for term in commonSearches {
                _ = self.searchElements(query: term) // Cache these common searches
            }
            
            // 5. Notify that all search indexes are ready
            DispatchQueue.main.async {
                self.searchIndexesReady = true
            }
        }
    }
    
    func searchElements(query: String) -> [Element] {
        // Return all elements for empty query
        if query.isEmpty {
            return elements
        }
        
        // Check cache first for fastest possible return
        let searchText = query.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        if let cachedResults = searchCache[searchText] {
            return cachedResults
        }
        
        var results: [Element] = []
        
        // Check for atomic number (fastest possible lookup)
        if let number = Int(searchText), let element = atomicNumberMap[number] {
            results = [element]
        }
        // Check for exact symbol match
        else if let element = symbolExactMap[searchText] {
            results = [element]
        }
        // Check for exact name match
        else if let element = nameExactMap[searchText] {
            results = [element]
        }
        // Check for prefix match in symbols (most common for symbol search)
        else if let matches = symbolIndexes[searchText] {
            results = matches
        }
        // Check for prefix match in names (most common for name search)
        else if let matches = nameIndexes[searchText] {
            results = matches
        }
        // Check categories
        else if let matches = categoryMap[searchText] {
            results = matches
        }
        // Fallback to contains search if no exact or prefix matches
        else {
            results = elements.filter { element in
                element.name.lowercased().contains(searchText) ||
                element.symbol.lowercased().contains(searchText) ||
                element.category.lowercased().contains(searchText)
            }
        }
        
        // Cache results for future searches (only for shorter queries to limit memory usage)
        if searchText.count <= 10 {
            searchCache[searchText] = results
        }
        
        return results
    }
    
    // Clear caches if memory warning occurs
    func clearCaches() {
        searchCache.removeAll(keepingCapacity: true)
    }
}
