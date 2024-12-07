//
//  ContentViewModel.swift
//  Recipes
//
//  Created by Victor Ulloa on 2024-11-14.
//

import Foundation
import Combine

final class ContentViewModel: ObservableObject {
    @Published var recipes: [Recipe] = []
    @Published var errorMessage: IdentifiableError?
    
    private var cancellables = Set<AnyCancellable>()
    private let networkManager = NetworkManager()
    
    func loadAllRecipes() {
        networkManager.fetchAllRecipes()
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    self.errorMessage = IdentifiableError(message: error.localizedDescription)
                }
            }, receiveValue: { [weak self] recipes in
                self?.recipes = recipes
            })
            .store(in: &cancellables)
    }
    
    func deleteRecipe(at offsets: IndexSet) {
        offsets.forEach { index in
            let recipeToDelete = recipes[index]
            
            networkManager.deleteRecipe(by: recipeToDelete.id)
                .sink(receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        self.errorMessage = IdentifiableError(message: error.localizedDescription)
                    }
                }, receiveValue: { [weak self] in
                    self?.recipes.remove(at: index)
                })
                .store(in: &cancellables)
        }
    }
    
    func addRecipe(_ recipe: Recipe) {
        networkManager.addRecipe(recipe)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    self.errorMessage = IdentifiableError(message: error.localizedDescription)
                }
            }, receiveValue: { [weak self] newRecipe in
                if let recipe = newRecipe {
                    self?.recipes.append(recipe)
                } else {
                    self?.recipes.append(recipe) // Add the original recipe for local display
                }
            })
            .store(in: &cancellables)
    }
}
