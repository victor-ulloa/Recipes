//
//  NetworkManager.swift
//  Recipes
//
//  Created by Victor Ulloa on 2024-11-14.
//

import Foundation
import Combine

class NetworkManager {
    private let baseURL = "https://a1-express-api.onrender.com/recipes"
    
    func fetchAllRecipes() -> AnyPublisher<[Recipe], Error> {
        guard let url = URL(string: baseURL) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [Recipe].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func fetchRecipe(by id: Int) -> AnyPublisher<Recipe, Error> {
        guard let url = URL(string: "\(baseURL)/\(id)") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: Recipe.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
