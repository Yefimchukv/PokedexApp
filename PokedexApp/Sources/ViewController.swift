//
//  ViewController.swift
//  PokedexApp
//
//  Created by Vitaliy Yefimchuk on 20.06.2021.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var pokemonImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var randomizeButtom: UIButton!
    
    var pokemonService: StorageServiceProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pokemonService = StorageService(pokemons: [
            Pokemon(name: "Pikachu", type: "Electric"),
            Pokemon(name: "Sandshrew", type: "Ground"),
        ])
        
    }
    
    @IBAction func randomizeButtonTapepd(_ sender: UIButton) {
        let pokemon = pokemonService.getPokemon()
        let image = pokemon.name.lowercased()
        
        titleLabel.text = pokemon.name
        subtitleLabel.text = pokemon.type
        pokemonImage.image = UIImage(named: image)
    }
    
}

