//
//  AddRecipeView.swift
//  Recipes
//
//  Created by Victor Ulloa on 2024-12-06.
//

import SwiftUI

struct AddRecipeView: View {
    @State private var recipe = Recipe(id: 0, recipeName: "", ingredients: [], cookingTime: 0, difficulty: 0, cuisine: "", description: "", photoLink: "", averageRating: 0.0)
    var onSave: (Recipe) -> Void

    var body: some View {
        NavigationView {
            Form {
                TextField("Recipe Name", text: $recipe.recipeName)
                TextField("Cuisine", text: $recipe.cuisine)
                TextField("Ingredients", text: Binding(get: {
                    recipe.ingredients.joined(separator: ", ")
                }, set: { newValue in
                    recipe.ingredients = newValue.split(separator: ",").map { String($0).trimmingCharacters(in: .whitespaces) }
                }))
                TextField("Cooking Time", value: $recipe.cookingTime, formatter: NumberFormatter())
                TextField("Difficulty", value: $recipe.difficulty, formatter: NumberFormatter())
                TextField("Description", text: $recipe.description)
                TextField("Photo Link", text: $recipe.photoLink)
                TextField("Rating", value: $recipe.averageRating, formatter: NumberFormatter())
            }
            .navigationTitle("Add Recipe")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        onSave(recipe)
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        // Handle cancel action
                    }
                }
            }
        }
    }
}
