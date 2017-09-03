//
//  Pokemon.swift
//  Pokemon
//
//  Created by Jack Ily on 03/09/2017.
//  Copyright © 2017 Jack Ily. All rights reserved.
//

import UIKit
import Alamofire

class Pokemon {
    
    var name: String
    var pokemonID: Int
    
    var _descriptions: String!
    var _type: String!
    var _defense: String!
    var _height: String!
    var _weight: String!
    var _attack: String!
    var _evolutionName: String!
    var _evolutionID: String!
    var _evolutionLevel: String!
    
    var urlPokemon: String
    
    var descriptions: String {
        if _descriptions == nil {
            _descriptions = ""
        }
        return _descriptions
    }
    
    var type: String {
        if _type == nil {
            _type = ""
        }
        return _type
    }
    
    var defense: String {
        if _defense == nil {
            _defense = ""
        }
        return _defense
    }
    
    var height: String {
        if _height == nil {
            _height = ""
        }
        return _height
    }
    
    var weight: String {
        if _weight == nil {
            _weight = ""
        }
        return _weight
    }
    
    var attack: String {
        if _attack == nil {
            _attack = ""
        }
        return _attack
    }
    
    var evolutionName: String {
        if _evolutionName == nil {
            _evolutionName = ""
        }
        return _evolutionName
    }
    
    var evolutionID: String {
        if _evolutionID == nil {
            _evolutionID = ""
        }
        return _evolutionID
    }
    
    var evolutionLevel: String {
        if _evolutionLevel == nil {
            _evolutionLevel = ""
        }
        return _evolutionLevel
    }
    
    init(name: String, pokemonID: Int) {
        self.name = name
        self.pokemonID = pokemonID
        
        urlPokemon = "\(baseURL)\(pokemonURL)"
    }
    
    func downloadPokemonDetail(complete: @escaping DownloadComplete) {
        let url = "\(urlPokemon)\(pokemonID)/"
        Alamofire.request(url).responseJSON { (response) in
            if let dict = response.result.value as? Dictionary<String, Any> {
                
                if let descrip = dict["descriptions"] as? [Dictionary<String, String>], descrip.count > 0 {
                    
                    if let uri = descrip[0]["resource_uri"] {
                        let url = "\(baseURL)\(uri)"
                        Alamofire.request(url).responseJSON(completionHandler: { (response) in
                            if let desDict = response.result.value as? Dictionary<String, Any> {
                                if let description = desDict["description"] as? String {
                                    self._descriptions = description.replacingOccurrences(of: "POKE", with: "Pokemon")
                                }
                            }
                            
                            complete()
                        })
                    }
                }
                
                if let type = dict["types"] as? [Dictionary<String, String>], type.count > 0 {
                    
                    if let name = type[0]["name"] {
                        self._type = name.capitalized
                    }
                    
                    if type.count > 1 {
                        for i in 1..<type.count {
                            if let name = type[i]["name"] {
                                self._type! += "/\(name.capitalized)"
                            }
                        }
                    }
                    
                } else {
                    self._type = ""
                }
                
                if let defense = dict["defense"] as? Int {
                    self._defense = "\(defense)"
                }
                
                if let height = dict["height"] as? String {
                    self._height = height
                }
                
                if let weight = dict["weight"] as? String {
                    self._weight = weight
                }
                
                if let attack = dict["attack"] as? Int {
                    self._attack = "\(attack)"
                }
                
                if let evolution = dict["evolutions"] as? [Dictionary<String, Any>], evolution.count > 0 {
                    if let evoName = evolution[0]["to"] as? String {
                        if evoName.range(of: "mega") == nil {
                            self._evolutionName = evoName
                            
                            if let uri = evolution[0]["resource_uri"] as? String {
                                let nextEvo = uri.replacingOccurrences(of: "/api/v1/pokemon/", with: "")
                                let nextEvoID = nextEvo.replacingOccurrences(of: "/", with: "")
                                self._evolutionID = nextEvoID
                                
                                if let level = evolution[0]["level"] as? Int {
                                    self._evolutionLevel = "\(level)"
                                    
                                } else {
                                    self._evolutionLevel = ""
                                }
                            }
                        }
                    }
                }
            }
            complete()
        }
    }
}
