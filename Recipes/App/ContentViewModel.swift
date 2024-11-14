//
//  ContentViewModel.swift
//  Recipes
//
//  Created by Victor Ulloa on 2024-11-14.
//

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
}
