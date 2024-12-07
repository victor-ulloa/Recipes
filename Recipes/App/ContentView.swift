//
//  ContentView.swift
//  Recipes
//
//  Created by Victor Ulloa on 2024-11-14.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel()
    @State private var showAddRecipe = false

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.recipes) { recipe in
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
                .onDelete(perform: viewModel.deleteRecipe(at:))
            }
            .onAppear {
                viewModel.loadAllRecipes()
            }
            .navigationTitle("Recipes")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showAddRecipe.toggle() }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showAddRecipe) {
                AddRecipeView { newRecipe in
                    viewModel.addRecipe(newRecipe)
                }
            }
            .alert(item: $viewModel.errorMessage) { error in
                Alert(title: Text("Error"), message: Text(error.message), dismissButton: .default(Text("OK")))
            }
        }
    }
}

#Preview {
    ContentView()
}
