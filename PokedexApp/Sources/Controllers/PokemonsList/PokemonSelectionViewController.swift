//
//  PokemonSelectionViewController.swift
//  PokedexApp
//
//  Created by Vitaliy Yefimchuk on 29.06.2021.
//

import UIKit

class PokemonSelectionViewController: UIViewController {
    
    typealias DataSource = UITableViewDiffableDataSource<Int, Pokemon>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, Pokemon>
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchField: UITextField!
    
    private var tokens: [AnyObject] = []
    
    var pokemonService: StorageServiceProtocol!
    
    lazy var notificationCenter: NotificationCenter = .default
    
    private lazy var dataSource: DataSource = {
        return DataSource(tableView: tableView) { (tableView, indexPath, pokemon) -> UITableViewCell? in
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonCell", for: indexPath)
            
            cell.textLabel?.text = pokemon.name
            cell.imageView?.image = UIImage(named: "\(pokemon.name.lowercased())")
            
            return cell
        }
    }()
    
    @IBAction func search(_ sender: Any) {
        guard let query = searchField.text,
              query.count > 0 else {
            pokemons = pokemonService.allPokemons
            return
        }
        pokemons = pokemonService.search(for: query)
    }
    
    private var pokemons: [Pokemon] {
        set {
            var snapshot = Snapshot()
            snapshot.appendSections([0])
            snapshot.appendItems(newValue, toSection: 0)
            dataSource.apply(snapshot, animatingDifferences: true, completion: nil)
        }
        
        get {
            dataSource.snapshot().itemIdentifiers(inSection: 0)
        }
    }
    
    deinit {
        tokens.forEach{ notificationCenter.removeObserver($0) }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = dataSource
        pokemonService = StorageService()
        pokemonService.loadPokemons()
        tableView.reloadData()
        pokemons = pokemonService.allPokemons
        subscribe()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let destination = segue.destination as? PokemonDetailsViewController else { return }
        
        guard let selection = tableView.indexPathForSelectedRow else { return }
        
        let pokemon = pokemons[selection.row]
        destination.currentPokemon = pokemon
    }
    
    // MARK: - Private functions
    private func subscribe() {
        let token = notificationCenter.addObserver(
            forName: UITextField.keyboardWillChangeFrameNotification,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            
            guard let self = self,
                  let info = notification.userInfo,
                  let frame = info[UITextField.keyboardFrameEndUserInfoKey] as? CGRect,
                  let duration = info[UITextField.keyboardAnimationDurationUserInfoKey] as? TimeInterval
            else { return }
            
            self.bottomConstraint.constant = 0
            self.view.layoutIfNeeded()
            
            let viewFrame = self.view.convert(self.tableView.frame, to: nil)
            let intersection = (viewFrame).intersection(frame)
            
            
            self.bottomConstraint.constant = intersection.height
            
            UIView.animate(withDuration: duration) {
                self.view.layoutIfNeeded()
            }
        }
        tokens.append(token)
    }
}
