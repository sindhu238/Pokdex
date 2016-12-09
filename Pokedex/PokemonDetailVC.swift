//
//  PokemonDetailVC.swift
//  Pokedex
//
//  Created by Venkateswara on 08/12/16.
//  Copyright © 2016 Sindhu. All rights reserved.
//

import UIKit
import AVFoundation

class PokemonDetailVC: UIViewController {

    @IBOutlet weak var pokeName: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var details: UILabel!
    @IBOutlet weak var pokeType: UILabel!
    @IBOutlet weak var defence: UILabel!
    @IBOutlet weak var height: UILabel!
    @IBOutlet weak var pokeID: UILabel!
    @IBOutlet weak var weight: UILabel!
    @IBOutlet weak var baseAttack: UILabel!
    @IBOutlet weak var currentEvoImage: UIImageView!
    @IBOutlet weak var nextEvoImage: UIImageView!
    @IBOutlet weak var nextEvolutionLabel: UILabel!
    
    
    
    var pokemon : Pokemon!
    var player : AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pokeName.text = pokemon.name.capitalized
        let img = UIImage(named: "\(self.pokemon.pokedexId)")
        mainImage.image = img
        currentEvoImage.image = img 
        pokemon.downloadPokemonDetails {
            self.defence.text = "\(self.pokemon.defense)"
            self.height.text = "\(self.pokemon.height)"
            self.weight.text = "\(self.pokemon.weight)"
            self.baseAttack.text = "\(self.pokemon.attack)"
            self.pokeID.text = "\(self.pokemon.pokedexId)"
            self.pokeType.text = "\(self.pokemon.type)"
            self.pokeType.text = self.pokemon.type
            self.details.text = self.pokemon.details
            self.nextEvoImage.image = UIImage(named: "\(self.pokemon.nextEvolutionText)")
        }
    }
    
    @IBAction func onBackPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onMusicClicked(_ sender: UIButton) {
        if player.isPlaying {
            player.pause()
        } else {
            player.play()
        }
    }
}
