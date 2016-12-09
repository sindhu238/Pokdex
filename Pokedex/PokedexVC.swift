//
//  PokedexVC.swift
//  Pokedex
//
//  Created by Venkateswara on 07/12/16.
//  Copyright © 2016 Sindhu. All rights reserved.
//

import UIKit
import AVFoundation

class PokedexVC: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
  
    var player : AVAudioPlayer?
    var pokemon = [Pokemon]()
    var filteredPokemon = [Pokemon]()
    var isSearch = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.done
        parseCSV()
        initAudio()
    }
    
    func initAudio() {
        let path = Bundle.main.url(forResource: "music", withExtension: "mp3")!
        
        do {
            player = try AVAudioPlayer(contentsOf: path)
            player?.prepareToPlay()
            player?.numberOfLoops = -1
            player?.play()
            
        } catch let error as NSError {
            print("\(error.debugDescription)")
        }
    }
    
    func parseCSV() {
        
        let path = Bundle.main.path(forResource: "pokemon", ofType: "csv")!
        do {
            let csv = try CSV(contentsOfURL: path)
            let rows = csv.rows
            for row in rows {
                let pokeID = Int(row["id"]!)!
                let name = row["identifier"]!
                let poke = Pokemon(name: name, pokedexId: pokeID)
                pokemon.append(poke)
            }
        } catch let err as NSError {
            print(err.debugDescription)
        }
        collectionView.reloadData()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isSearch {
            return filteredPokemon.count
        } else {
            return pokemon.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokeCell", for: indexPath) as? PokeCell {
            var pokemon : Pokemon
            if isSearch {
                pokemon = filteredPokemon[indexPath.row]
            } else {
                pokemon = self.pokemon[indexPath.row]
            }
            cell.configureCell(pokemon)
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isSearch {
            performSegue(withIdentifier: "PokemonDetail", sender: filteredPokemon[indexPath.row])
        } else {
            performSegue(withIdentifier: "PokemonDetail", sender: pokemon[indexPath.row])
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? PokemonDetailVC {
            destination.pokemon = sender as? Pokemon
            destination.player = player
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize{
        return CGSize(width: 105, height: 105)
    }
    
    @IBAction func onMusicBtnPressed(_ sender: UIButton) {
        if (player?.isPlaying)! {
            player?.pause()
            sender.alpha = 0.5
            
        } else {
            player?.play()
            sender.alpha = 1.0
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard searchText == "" else {
            isSearch = true
            let lowerText = searchText.lowercased()
            filteredPokemon = pokemon.filter({($0.name.range(of: lowerText) != nil) })
            collectionView.reloadData()
            return
        }
        isSearch = false
        collectionView.reloadData()
        view.endEditing(true)
    }
    
}

