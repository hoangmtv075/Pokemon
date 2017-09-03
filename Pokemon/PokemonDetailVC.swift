//
//  PokemonDetailVC.swift
//  Pokemon
//
//  Created by Jack Ily on 04/09/2017.
//  Copyright © 2017 Jack Ily. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController {
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var pokeImageView: UIImageView!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var defenseLbl: UILabel!
    @IBOutlet weak var heightLbl: UILabel!
    @IBOutlet weak var weightLbl: UILabel!
    @IBOutlet weak var pokemonIDLbl: UILabel!
    @IBOutlet weak var attackLbl: UILabel!
    @IBOutlet weak var nextEvoLbl: UILabel!
    @IBOutlet weak var currentEvoImageView: UIImageView!
    @IBOutlet weak var nextEvoImageView: UIImageView!
    
    var pokemon: Pokemon!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLbl.text = pokemon.name.capitalized
        
        let p = pokemon.pokemonID
        pokeImageView.image = UIImage(named: "\(p)")
        pokemonIDLbl.text = "\(p)"
        currentEvoImageView.image = UIImage(named: "\(p)")
        
        heightLbl.text = ""
        weightLbl.text = ""
        defenseLbl.text = ""
        attackLbl.text = ""
        typeLbl.text = ""
        descriptionLbl.text = ""
        nextEvoLbl.text = "Next Evolutions:"
        nextEvoImageView.image = nil
        
        pokemon.downloadPokemonDetail { 
            self.updateUI()
        }
    }
    
    func updateUI() {
        heightLbl.text = pokemon.height
        weightLbl.text = pokemon.weight
        defenseLbl.text = pokemon.defense
        attackLbl.text = pokemon.attack
        typeLbl.text = pokemon.type
        descriptionLbl.text = pokemon.descriptions
        
        if pokemon.evolutionID == "" {
            nextEvoLbl.text = "No Evolutions"
            nextEvoImageView.isHidden = true
            
        } else {
            nextEvoImageView.isHidden = false
            nextEvoImageView.image = UIImage(named: "\(pokemon.evolutionID)")
            nextEvoLbl.text = "Next Evolutions: \(pokemon.evolutionName) - Level \(pokemon.evolutionLevel)"
        }
    }
    
    @IBAction func backBtn() {
        dismiss(animated: true, completion: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
