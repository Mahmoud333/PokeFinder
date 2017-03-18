//
//  ChoosePokemonCell.swift
//  PokeFinder (Udemy)
//
//  Created by Mahmoud Hamad on 2/11/17.
//  Copyright © 2017 Mahmoud SMGL. All rights reserved.
//

import UIKit

class ChoosePokemonCell: UICollectionViewCell {
    
    @IBOutlet weak var pokemonImage: UIImageView!
    @IBOutlet weak var pokemonLabel: UILabel!
    
    func configuerCell(Poke: Pokemon) {
    
        self.clipsToBounds = true
        self.layer.cornerRadius = 14
        
        pokemonLabel.text = Poke.pokeName.capitalized
        
        pokemonImage.image = UIImage(named: "\(Poke.pokeId)")

    }
}
