//
//  Recipe.swift
//  Recipes
//
//  Created by Victor Ulloa on 2024-11-14.
//

import Foundation

struct Recipe: Codable, Identifiable {
    let id: Int
    let recipeName: String
    let ingredients: [String]
    let cookingTime: Int
    let difficulty: Int
    let cuisine: String
    let description: String
    let photoLink: String
    let averageRating: Double

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case recipeName, ingredients, cookingTime, difficulty, cuisine, description, photoLink, averageRating
    }
}
