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

    func deleteRecipe(id: Int) {
        networkManager.deleteRecipe(id: id)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    self.errorMessage = IdentifiableError(message: error.localizedDescription)
                }
            }, receiveValue: { [weak self] in
                self?.recipes.removeAll { $0.id == id }
            })
            .store(in: &cancellables)
    }

    func createRecipe(_ recipe: Recipe) {
        networkManager.createRecipe(recipe)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    self.errorMessage = IdentifiableError(message: error.localizedDescription)
                }
            }, receiveValue: { [weak self] newRecipe in
                self?.recipes.append(newRecipe)
            })
            .store(in: &cancellables)
    }

    func editRecipe(_ recipe: Recipe) {
        networkManager.editRecipe(recipe)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    self.errorMessage = IdentifiableError(message: error.localizedDescription)
                }
            }, receiveValue: { [weak self] updatedRecipe in
                if let index = self?.recipes.firstIndex(where: { $0.id == updatedRecipe.id }) {
                    self?.recipes[index] = updatedRecipe
                }
            })
            .store(in: &cancellables)
    }
}
