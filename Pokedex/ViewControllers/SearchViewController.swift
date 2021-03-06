//
//  SearchViewController.swift
//  Pokedex
//
//  Created by Chris Price on 3/21/20.
//  Copyright © 2020 com.chrispriiice. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var pokemonNameLabel: UILabel!
    @IBOutlet weak var pokemonIDLabel: UILabel!
    @IBOutlet weak var pokemonTypesLabel: UILabel!
    @IBOutlet weak var pokemonAbilitiesLabel: UILabel!
    @IBOutlet weak var pokemonImageView: UIImageView!
    
    
    var pokemonController: PokemonController?
    var pokemon: Pokemon? {
        didSet {
            self.updateViews()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        self.updateViews()
    }
    
    func updateViews() {
        guard var pokemon = pokemon else { return }
        pokemonNameLabel.text = pokemon.name.capitalized
        pokemonIDLabel.text = "\(pokemon.id)"
        pokemonAbilitiesLabel.text = pokemon.abilities.map({$0.ability.name}).joined(separator: ", ")
        pokemonTypesLabel.text = pokemon.types.map({$0.type.name}).joined(separator: ", ")
        pokemonController?.fetchImage(urlString: pokemon.sprites.frontDefault, completion: { (result) in
            if let pokemonSearchResult = try? result.get() {
                DispatchQueue.main.async {
                    // pokemon.image = pokemonSearchResult
                    self.pokemonImageView.image = UIImage(data: pokemonSearchResult)
                    pokemon.image = pokemonSearchResult
                    self.pokemon = pokemon 
                }
            }
        })
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let pokemon = pokemon else { return }
        pokemonController?.savePokemon(pokemon: pokemon)
        navigationController?.popViewController(animated: true)
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchTerm = searchBar.text else { return }
        pokemonController?.fetchPokemon(name: searchTerm, completion: { (result) in
            if let pokemonSearchResult = try? result.get() {
                DispatchQueue.main.async {
                    self.pokemon = pokemonSearchResult
                }
            }
        })
    }
}
