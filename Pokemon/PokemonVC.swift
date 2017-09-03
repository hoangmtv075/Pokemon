//
//  PokemonVC.swift
//  Pokemon
//
//  Created by Jack Ily on 03/09/2017.
//  Copyright © 2017 Jack Ily. All rights reserved.
//

import UIKit
import AVFoundation

class PokemonVC: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var pokemons = [Pokemon]()
    
    var filter = [Pokemon]()
    var inSearchMode = false
    
    var audioPlayer: AVAudioPlayer!

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        
        searchBar.delegate = self
        searchBar.returnKeyType = .done
        
        downloadPokemon()
        
        musicAV()
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(gestureRecognizers))
        gestureRecognizer.cancelsTouchesInView = false
        collectionView.addGestureRecognizer(gestureRecognizer)
    }
    
    func downloadPokemon() {
        if let path = Bundle.main.path(forResource: "pokemon", ofType: "csv") {
            
            do {
                let csv = try CSV(contentsOfURL: path)
                let rows = csv.rows
                
                for row in rows {
                    let pokemonID = Int(row["id"]!)!
                    let name = row["identifier"]!
                    
                    let pokemon = Pokemon(name: name, pokemonID: pokemonID)
                    pokemons.append(pokemon)
                }
            } catch {
                print("Download Pokemon Error")
            }
        }
    }
    
    func gestureRecognizers(_ gestureRecognizer: UITapGestureRecognizer) {
        let point = gestureRecognizer.location(in: collectionView)
        let indexPath = collectionView.indexPathForItem(at: point)
        
        if indexPath != nil && indexPath!.section == 0 {
            return
        }
        searchBar.resignFirstResponder()
    }
    
    @IBAction func musicBtn(_ sender: UIButton) {
        if audioPlayer.isPlaying {
            audioPlayer.stop()
            sender.alpha = 0.5
            
        } else {
            audioPlayer.play()
            sender.alpha = 1.0
        }
    }
    
    func musicAV() {
        if let path = Bundle.main.path(forResource: "music", ofType: "mp3") {
            let url = NSURL(fileURLWithPath: path)
            audioPlayer = try! AVAudioPlayer(contentsOf: url as URL)
            audioPlayer.prepareToPlay()
            audioPlayer.numberOfLoops = -1
            audioPlayer.play()
        }
        let ss = AVAudioSession.sharedInstance()
        try! ss.setCategory(AVAudioSessionCategoryPlayback, with: .duckOthers)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PokemonDetailVC" {
            let controller = segue.destination as! PokemonDetailVC
            
            if let pokemon = sender as? Pokemon {
                controller.pokemon = pokemon
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension PokemonVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if inSearchMode {
            return filter.count
            
        } else {
            return pokemons.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokemonCell", for: indexPath) as! PokemonCell
        let pokemon: Pokemon!
        
        if inSearchMode {
            pokemon = filter[indexPath.row]
            cell.configureCell(pokemon)
            
        } else {
            pokemon = pokemons[indexPath.row]
            cell.configureCell(pokemon)
        }
        
        return cell
    }
}

extension PokemonVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let pokemon: Pokemon!
        
        if inSearchMode {
            pokemon = filter[indexPath.row]
            
        } else {
            pokemon = pokemons[indexPath.row]
        }
        
        performSegue(withIdentifier: "PokemonDetailVC", sender: pokemon)
    }
}

extension PokemonVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 100, height: 130)
    }
}

extension PokemonVC: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            inSearchMode = false
            collectionView.reloadData()
            view.endEditing(true)
            
        } else {
            inSearchMode = true
            filter = pokemons.filter({ $0.name.lowercased().range(of: searchText.lowercased(), options: [.caseInsensitive, .diacriticInsensitive], locale: .current) != nil })
            collectionView.reloadData()
        }
    }
}
