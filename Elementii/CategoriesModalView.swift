//
//  CategoriesModalView.swift
//  Elementii
//
//  Created by Petar Vidakovic on 2025-03-05.
//

import SwiftUI

struct CategoriesModalView: View {
    let categories: [String]
    @Binding var selectedCategory: String?
    
    var body: some View {
        NavigationView {
            List(categories, id: \.self) { category in
                Button(action: {
                    selectedCategory = selectedCategory == category ? nil : category
                }) {
                    HStack {
                        Text(category)
                        Spacer()
                        if selectedCategory == category {
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }
            .navigationTitle("Categories")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        // Dismiss the modal
                    }
                }
            }
        }
    }
}
