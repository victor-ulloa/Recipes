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
    
    func deleteRecipe(id: Int) -> AnyPublisher<Void, Error> {
        guard let url = URL(string: "\(baseURL)/\(id)") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map { _ in () } // Map response to Void as we don't expect any data
            .mapError { $0 as Error } // Map URLError to generic Error
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func createRecipe(_ recipe: Recipe) -> AnyPublisher<Recipe, Error> {
        guard let url = URL(string: baseURL) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let data = try JSONEncoder().encode(recipe)
            request.httpBody = data
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: Recipe.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func editRecipe(_ recipe: Recipe) -> AnyPublisher<Recipe, Error> {
        guard let url = URL(string: "\(baseURL)/\(recipe.id)") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let data = try JSONEncoder().encode(recipe)
            request.httpBody = data
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: Recipe.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
