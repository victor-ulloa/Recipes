//
//  IdentifiableError.swift
//  Recipes
//
//  Created by Victor Ulloa on 2024-11-14.
//

import Foundation

struct IdentifiableError: Identifiable {
    let id = UUID()
    let message: String
}
