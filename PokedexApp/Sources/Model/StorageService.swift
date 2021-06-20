//
//  StorageService.swift
//  PokedexApp
//
//  Created by Vitaliy Yefimchuk on 20.06.2021.
//

import Foundation

protocol StorageServiceProtocol {
    func getPokemon() -> Pokemon
}

class StorageService: StorageServiceProtocol {
    var pokemons: [Pokemon]
    
    init(pokemons: [Pokemon]) {
        self.pokemons = pokemons
    }
    
    func getPokemon() -> Pokemon {
        return pokemons.randomElement()!
    }
}
