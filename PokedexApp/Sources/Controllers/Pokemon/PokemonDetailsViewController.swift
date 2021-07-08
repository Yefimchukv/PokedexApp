//
//  PokemonDetailsViewController.swift
//  PokedexApp
//
//  Created by Vitaliy Yefimchuk on 20.06.2021.
//

import UIKit

class PokemonDetailsViewController: UIViewController {
    @IBOutlet weak var pokemonImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var randomizeButtom: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var workingConstraint: NSLayoutConstraint!
    @IBOutlet weak var loadingConstraint: NSLayoutConstraint!
    
    var currentPokemon: Pokemon?
    
    var pokemonService: StorageServiceProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pokemonService = StorageService()
        pokemonService.loadPokemons()
        if let currentPokemon = currentPokemon {
            updateUI(for: currentPokemon)
        } else {
            refresh()
        }
    }
    
    @IBAction func randomizeButtonTapepd(_ sender: UIButton) {
        guard let container = self.pokemonImage.superview else { return }
        
        var perspectiveTransform = CATransform3DIdentity
        perspectiveTransform.m34 = 1.0 / 600.0
        
        self.workingConstraint.priority = .init(998.0)
        self.loadingConstraint.priority = .init(999.0)
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveEaseIn]) {
            container.layer.transform = CATransform3DRotate(perspectiveTransform, .pi / 2, 0, 1, 0)
            self.view.layoutIfNeeded()
            
        } completion: { _ in
            self.refresh()
            
            container.layer.transform = CATransform3DRotate(perspectiveTransform, .pi / 2, 0, -1, 0)
            self.workingConstraint.priority = .init(999.0)
            self.loadingConstraint.priority = .init(998.0)
            
            UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveEaseOut]) {
                container.layer.transform = CATransform3DIdentity
                self.view.layoutIfNeeded()
            }
        }
    }
    
    
    
    func refresh() {
        guard let pokemon = pokemonService.getPokemon() else { return }
        self.currentPokemon = pokemon
        
        updateUI(for: pokemon)
    }
    
    fileprivate func updateUI(for pokemon: Pokemon) {
        let image = pokemon.name.lowercased()
        titleLabel.text = pokemon.name
        subtitleLabel.text = pokemon.type
        pokemonImage.image = UIImage(named: image)
        
        self.collectionView.reloadData()
    }
}

extension PokemonDetailsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let pokemon = currentPokemon else { return 0 }
        
        return pokemon.stats.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokemonCell", for: indexPath)
        
        guard let statsCell = cell as? PokemonStatsCollectionViewCell else { return cell }
        
        guard let currentPokemon = currentPokemon else {
            return cell
        }
        
        guard let statsKeys = currentPokemon.stats[indexPath.row]?.keys.first,
              let statsValues = currentPokemon.stats[indexPath.item]?.values.first else { return cell }
        
        statsCell.statsLabel.text = "\(statsKeys): \(statsValues)"
        
        return cell
    }
    
    
}
