//
//  AddRecipeView.swift
//  Recipes
//
//  Created by Victor Ulloa on 2024-12-06.
//


import SwiftUI

struct AddRecipeView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var recipeName = ""
    @State private var ingredients = ""
    @State private var cookingTime = ""
    @State private var difficulty = ""
    @State private var cuisine = ""
    @State private var description = ""
    @State private var photoLink = ""
    @State private var averageRating = ""

    var onAddRecipe: (Recipe) -> Void

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Details")) {
                    TextField("Recipe Name", text: $recipeName)
                    TextField("Ingredients (comma-separated)", text: $ingredients)
                    TextField("Cooking Time (minutes)", text: $cookingTime)
                        .keyboardType(.numberPad)
                    TextField("Difficulty (1-5)", text: $difficulty)
                        .keyboardType(.numberPad)
                    TextField("Cuisine", text: $cuisine)
                    TextField("Description", text: $description)
                    TextField("Photo Link", text: $photoLink)
                    TextField("Average Rating (0.0-5.0)", text: $averageRating)
                        .keyboardType(.decimalPad)
                }
            }
            .navigationTitle("Add Recipe")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveRecipe()
                    }
                }
            }
        }
    }
    
    private func saveRecipe() {
        guard let cookingTime = Int(cookingTime),
              let difficulty = Int(difficulty),
              let averageRating = Double(averageRating) else {
            return
        }
        
        let newRecipe = Recipe(
            id: 0, // Placeholder for backend ID assignment
            recipeName: recipeName,
            ingredients: ingredients.components(separatedBy: ","),
            cookingTime: cookingTime,
            difficulty: difficulty,
            cuisine: cuisine,
            description: description,
            photoLink: photoLink,
            averageRating: averageRating
        )
        onAddRecipe(newRecipe)
        dismiss()
    }
}
