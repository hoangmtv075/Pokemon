//
//  PokemonCell.swift
//  Pokemon
//
//  Created by Jack Ily on 03/09/2017.
//  Copyright © 2017 Jack Ily. All rights reserved.
//

import UIKit

class PokemonCell: UICollectionViewCell {
    
    @IBOutlet weak var pokeImageView: UIImageView!
    @IBOutlet weak var pokeNameLbl: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.cornerRadius = 5
    }
    
    func configureCell(_ pokemon: Pokemon) {
        pokeImageView.image = UIImage(named: "\(pokemon.pokemonID)")
        pokeNameLbl.text = pokemon.name.capitalized
    }
}
