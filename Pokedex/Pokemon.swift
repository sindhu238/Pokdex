//
//  Pokemon.swift
//  Pokedex
//
//  Created by Venkateswara on 07/12/16.
//  Copyright © 2016 Sindhu. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    
    private var _name: String!
    private var _pokedexId: Int!
    private var _details: String!
    private var _type: String!
    private var _defence: Int!
    private var _height: String!
    private var _weight: String!
    private var _baseAttack: Int!
    private var _nextEvolutionText: String!
    private var pokeURL: String!
    
    var name: String {
        return _name
    }
    
    var pokedexId: Int {
        return _pokedexId
    }
    
    var details: String {
        if _details == nil {
            _details = ""
        }
        return _details
    }
    
    var type: String {
        if _type == nil {
            _type = ""
        }
        return _type
    }
    
    var defense: Int {
        if _defence == nil {
            _defence = 0
        }
        return _defence
    }
    
    var attack: Int {
        if _baseAttack == nil {
            _baseAttack = 0
        }
        return _baseAttack
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

    var nextEvolutionText: String {
        if _nextEvolutionText == nil {
            _nextEvolutionText = ""
        }
        return _nextEvolutionText
    }
    
    init(name: String, pokedexId: Int) {
        self._name = name
        self._pokedexId = pokedexId
        self.pokeURL = "\(BASE_URL)\(POKE_URL)\(self._pokedexId!)/"
    }
    
    func downloadPokemonDetails(completed: @escaping DownloadComplete) {
        print("\(self.pokeURL!)")

        Alamofire.request(self.pokeURL!).responseJSON { response in
            switch response.result {
            case .success(let json as Dictionary<String, AnyObject>):
                if let attact = json["attack"] {
                    self._baseAttack = attact as? Int
                }
                if let defense = json["defense"] {
                    self._defence = defense as? Int
                }
                if let height = json["height"] {
                    self._height = height as? String
                }
                if let weight = json["weight"] {
                    self._weight = weight as? String
                }
                if let types = json["types"] as? [Dictionary<String, String>], types.count>0 {
                    var temp = ""
                    for i in 0...types.count-1 {
                        if let name = types[i]["name"] {
                            if temp == "" {
                                temp.append(name.capitalized)
                            } else{
                                temp.append("/\(name.capitalized)")
                            }
                            
                            self._type = temp
                        }
                        
                    }
                    
                } else {
                    self._type = "None"
                }
                if let descs = json["descriptions"] as? [Dictionary<String, String>] {
                    if let uri = descs[0]["resource_uri"] {
                        let url = "\(BASE_URL)\(uri)"
                        Alamofire.request(url).responseJSON(completionHandler: { (response) in
                            if let newJson = response.result.value as? Dictionary<String, AnyObject> {
                                print("sindhu0")
                                print("\(newJson)")
                                if let desc = newJson["description"] as? String {
                                    print("Description \(desc) sdfsd")
                                    self._details = desc
                                }
                            }
                            print("height \(self.height) \(self.details)")
                            completed()
                        })
                    }
                }

                if let evolutions = json["evolutions"] as? [Dictionary<String,AnyObject>], evolutions.count > 0 {
                    if let uri = evolutions[0]["resource_uri"] as? String {
                        let url = "\(BASE_URL)\(uri)"
                        Alamofire.request(url).responseJSON(completionHandler: { (response) in
                            switch response.result {
                            case .success:
                                print("success1 \(url)")
                                if let resp = response.result.value as? Dictionary<String, AnyObject> {
                                    if let desc = resp["descriptions"] as? [Dictionary<String, AnyObject>] , desc.count > 0 {
                                       let id = desc[0]["resource_uri"]
                                        let newid1 = id?.replacingOccurrences(of: "/api/v1/description/", with: "")
                                        print("success2")
                                        let newid2 = newid1?.replacingOccurrences(of: "/", with: "")
                                        print("id new \(newid2)")
                                        self._nextEvolutionText = newid2!
                                    }
                                }
                            case .failure(let error):
                                print("\(error.localizedDescription)")
                            }
                            completed()
                        })
                    }
                }
                
                
            case .failure(let error):
                print("Error in download pokemon data \(error.localizedDescription)")
            default:
                return
            }
            print("hi2")
            completed()
            
            
        }
        
    }
    
}
