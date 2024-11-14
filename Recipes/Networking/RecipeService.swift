//
//  RecipeService.swift
//  Recipes
//
//  Created by Victor Ulloa on 2024-11-14.
//

import Foundation

class RecipeService {
    private let baseURL = "https://a1-express-api.onrender.com/recipes"

    // Fetch all recipes
    func fetchAllRecipes(completion: @escaping (Result<[Recipe], Error>) -> Void) {
        guard let url = URL(string: baseURL) else {
            completion(.failure(NetworkingError.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkingError.noData))
                return
            }
            
            do {
                let recipes = try JSONDecoder().decode([Recipe].self, from: data)
                completion(.success(recipes))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }

    // Fetch a specific recipe by ID
    func fetchRecipe(byID id: Int, completion: @escaping (Result<Recipe, Error>) -> Void) {
        let urlString = "\(baseURL)/\(id)"
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkingError.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkingError.noData))
                return
            }
            
            do {
                let recipe = try JSONDecoder().decode(Recipe.self, from: data)
                completion(.success(recipe))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}

// Networking errors
enum NetworkingError: Error {
    case invalidURL
    case noData
}
