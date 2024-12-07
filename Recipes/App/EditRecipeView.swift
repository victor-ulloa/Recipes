//
//  EditRecipeView.swift
//  Recipes
//
//  Created by Victor Ulloa on 2024-12-06.
//

import SwiftUI

struct EditRecipeView: View {
    @State var recipe: Recipe
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
            .navigationTitle("Edit Recipe")
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
