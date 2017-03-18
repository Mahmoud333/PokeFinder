//
//  Pokemon.swift
//  PokeFinder (Udemy)
//
//  Created by Mahmoud Hamad on 2/13/17.
//  Copyright © 2017 Mahmoud SMGL. All rights reserved.
//

import Foundation

class Pokemon {
    
    private var _PokeName: String!
    private var _PokeId: Int!
    
    //Set Them
    init(pokeName: String,pokeId: Int) {
        self._PokeName = pokeName
        self._PokeId = pokeId
    }
    
    //Get them
    var pokeName: String {
        get {
            return _PokeName
        }
    }
    var pokeId: Int {
        get {
            return _PokeId
        }
    }
    
}
