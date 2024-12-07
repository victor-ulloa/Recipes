//
//  Recipe.swift
//  Recipes
//
//  Created by Victor Ulloa on 2024-11-14.
//

import Foundation

struct Recipe: Codable, Identifiable {
    var id: Int
    var recipeName: String
    var ingredients: [String]
    var cookingTime: Int
    var difficulty: Int
    var cuisine: String
    var description: String
    var photoLink: String
    var averageRating: Double

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case recipeName, ingredients, cookingTime, difficulty, cuisine, description, photoLink, averageRating
    }
}
