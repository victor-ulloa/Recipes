//
//  ContentView.swift
//  Recipes
//
//  Created by Victor Ulloa on 2024-11-14.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel()
    
    var body: some View {
        NavigationView {
            List(viewModel.recipes) { recipe in
                VStack(alignment: .leading) {
                    Text(recipe.recipeName)
                        .font(.headline)
                    Text(recipe.cuisine)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text("Rating \(recipe.averageRating, specifier: "%.2f") ⭐️")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            .onAppear {
                viewModel.loadAllRecipes()
            }
            .navigationTitle("Recipes")
            .alert(item: $viewModel.errorMessage) { error in
                Alert(title: Text("Error"), message: Text(error.message), dismissButton: .default(Text("OK")))
            }
        }
    }
}

#Preview {
    ContentView()
}
