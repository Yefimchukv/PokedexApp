//
//  StorageService.swift
//  PokedexApp
//
//  Created by Vitaliy Yefimchuk on 20.06.2021.
//

import Foundation

protocol StorageServiceProtocol {
    func getPokemon() -> Pokemon?
    func loadPokemons()
    func search(for query: String) -> [Pokemon]
    
    var allPokemons: [Pokemon] { get }
}

class StorageService: StorageServiceProtocol {
    
    
    var pokemons: [Pokemon] = []
    
    func getPokemon() -> Pokemon? {
        guard pokemons.count != 0 else { return nil }
        return pokemons.randomElement()
    }
    
    var allPokemons: [Pokemon] {
        get { return pokemons }
    }
    
    func search(for query: String) -> [Pokemon] {
        pokemons.filter { return $0.name.lowercased().contains(query.lowercased()) }
    }
    
    func loadPokemons() {
        pokemons = [
            Pokemon(name: "Pikachu", type: "Electric", stats: [0: ["HP": 35], 1: ["Attack": 55], 2: ["Defence": 40], 3: ["Sp. Atk": 50], 4: ["Sp. Def": 50], 5: ["Speed": 90]]),
            Pokemon(name: "Sandshrew", type: "Ground", stats: [0: ["HP": 50], 1: ["Attack": 75], 2: ["Defence": 85], 3: ["Sp. Atk": 20], 4: ["Sp. Def": 30], 5: ["Speed": 40]])]
    }
}
