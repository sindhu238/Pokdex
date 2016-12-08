//
//  PokeCell.swift
//  Pokedex
//
//  Created by Venkateswara on 07/12/16.
//  Copyright © 2016 Sindhu. All rights reserved.
//

import UIKit

class PokeCell: UICollectionViewCell {
    
    @IBOutlet weak var pokeImage: UIImageView!
    @IBOutlet weak var pokeLabel: UILabel!
    
    var pokemon: Pokemon!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.cornerRadius = 5.0

    }
    
    func configureCell(_ pokemon: Pokemon) {
        self.pokemon = pokemon
        pokeImage.image = UIImage(named: "\(self.pokemon.pokedexId)")
        pokeLabel.text = self.pokemon.name.capitalized
    }
    
}
