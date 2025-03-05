//
//  ElementListView.swift
//  Elementii
//
//  Created by Petar Vidakovic on 2025-03-01.
//

import SwiftUI

struct ElementListView: View {
    let elements: [Element] = Bundle.main.decode("elements.json")
    @State private var searchText = ""
    @State private var selectedCategory: String? = nil
    @State private var showCategoriesPopover = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Search bar
            HStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                        .padding(.leading, 8)
                    
                    TextField("Search elements...", text: $searchText)
                        .padding(10)
                    
                    if !searchText.isEmpty {
                        Button(action: {
                            searchText = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                        .padding(.trailing, 8)
                    }
                }
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                
                Button(action: {
                    showCategoriesPopover = true
                }) {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                        .font(.title2)
                }
                .popover(isPresented: $showCategoriesPopover, arrowEdge: .top) {
                    CategoriesPopoverView(categories: getCategories(), selectedCategory: $selectedCategory)
                }
            }
            .padding()
            
            // Elements list
            List {
                // Main elements list
                ForEach(filteredElements, id: \.atomicNumber) { element in
                    NavigationLink(destination: ElementDetailView(element: element)) {
                        elementRow(element: element)
                    }
                }
            }
            .listStyle(PlainListStyle())
        }
        .navigationTitle("Elements")
    }
    
    // Element list row
    private func elementRow(element: Element) -> some View {
        HStack {
            // Element symbol in colored circle
            ZStack {
                Circle()
                    .fill(element.categoryColor)
                    .frame(width: 40, height: 40)
                
                Text(element.symbol)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
            }
            
            // Element details
            VStack(alignment: .leading, spacing: 4) {
                Text(element.name)
                    .font(.headline)
                
                HStack {
                    Text("\(element.atomicNumber)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    Text("•")
                        .foregroundColor(.gray)
                    
                    Text(element.category)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            .padding(.leading, 8)
            
            Spacer()
            
            // Atomic weight
            Text(String(format: "%.3f", element.atomicWeight))
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.gray)
        }
        .padding(.vertical, 6)
    }
    
    // Get unique categories from elements
    private func getCategories() -> [String] {
        return Array(Set(elements.map { $0.category })).sorted()
    }
    
    // Filter elements based on search text and selected category
    private var filteredElements: [Element] {
        elements.filter { element in
            let matchesSearch = searchText.isEmpty ||
                              element.name.lowercased().contains(searchText.lowercased()) ||
                              element.symbol.lowercased().contains(searchText.lowercased()) ||
                              String(element.atomicNumber).contains(searchText) ||
                              element.category.lowercased().contains(searchText.lowercased())
            
            let matchesCategory = selectedCategory == nil || element.category == selectedCategory
            
            return matchesSearch && matchesCategory
        }
        .sorted { $0.atomicNumber < $1.atomicNumber }
    }
}

// Categories popover for list
struct ListCategoriesPopoverView: View {
    let categories: [String]
    @Binding var selectedCategory: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Filter by Category")
                .font(.headline)
                .padding(.horizontal)
                .padding(.top)
            
            List {
                Button {
                    selectedCategory = nil
                } label: {
                    HStack {
                        Text("All Categories")
                            .foregroundColor(.primary)
                        Spacer()
                        if selectedCategory == nil {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }
                }
                
                ForEach(categories, id: \.self) { category in
                    Button {
                        selectedCategory = category
                    } label: {
                        HStack {
                            Text(category)
                                .foregroundColor(.primary)
                            
                            Spacer()
                            
                            if selectedCategory == category {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
            }
            .listStyle(PlainListStyle())
        }
        .frame(width: 300, height: 400)
    }
}

#Preview {
    NavigationView {
        ElementListView()
    }
}
