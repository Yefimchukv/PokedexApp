//
//  Pokemon.swift
//  PokedexApp
//
//  Created by Vitaliy Yefimchuk on 20.06.2021.
//

import Foundation

struct Pokemon {
    let name: String
    let type: String
    
    let stats: [Int: [String: Int]]
    
//    let image:
}

extension Pokemon: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(type)
    }
}

extension Pokemon: Equatable {
    static func == (lhs: Pokemon, rhs: Pokemon) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
}
