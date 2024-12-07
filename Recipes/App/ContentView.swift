//
//  ContentView.swift
//  Recipes
//
//  Created by Victor Ulloa on 2024-11-14.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel()
    @State private var isEditing: Bool = false
    @State private var selectedRecipe: Recipe?
    @State private var isAdding: Bool = false
    
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
                    .swipeActions {
                        // Swipe-to-delete functionality
                        Button(role: .destructive) {
                            viewModel.deleteRecipe(id: recipe.id)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                        
                        // Swipe-to-edit functionality (optional)
                        Button {
                            selectedRecipe = recipe
                            isEditing.toggle()
                        } label: {
                            Label("Edit", systemImage: "pencil")
                        }
                        .tint(.blue)
                    }
                    .contextMenu {
                        // Context menu options
                        Button(action: {
                            selectedRecipe = recipe
                            isEditing.toggle()
                        }) {
                            Text("Edit")
                            Image(systemName: "pencil")
                        }
                        Button(action: {
                            viewModel.deleteRecipe(id: recipe.id)
                        }) {
                            Text("Delete")
                            Image(systemName: "trash")
                        }
                    }
                }
                .onDelete(perform: delete)
            }
            .onAppear {
                viewModel.loadAllRecipes()
            }
            .navigationTitle("Recipes")
            .navigationBarItems(
                trailing: Button(action: {
                    isAdding.toggle()
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title)
                }
            )
            .alert(item: $viewModel.errorMessage) { error in
                Alert(title: Text("Error"), message: Text(error.message), dismissButton: .default(Text("OK")))
            }
            .sheet(isPresented: $isEditing) {
                // Edit recipe sheet
                if let selectedRecipe = selectedRecipe {
                    EditRecipeView(recipe: selectedRecipe, onSave: { updatedRecipe in
                        viewModel.editRecipe(updatedRecipe)
                        isEditing = false
                    })
                }
            }
            .sheet(isPresented: $isAdding) {
                // Add recipe sheet
                AddRecipeView(onSave: { newRecipe in
                    viewModel.createRecipe(newRecipe)
                    isAdding = false
                })
            }
        }
    }
    
    // Delete function for swipe-to-delete
    private func delete(at offsets: IndexSet) {
        for index in offsets {
            let recipe = viewModel.recipes[index]
            viewModel.deleteRecipe(id: recipe.id)
        }
    }
}

#Preview {
    ContentView()
}
