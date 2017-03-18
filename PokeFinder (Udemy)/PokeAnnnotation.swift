//
//  PokeAnnnotation.swift
//  PokeFinder (Udemy)
//
//  Created by Mahmoud Hamad on 2/8/17.
//  Copyright © 2017 Mahmoud SMGL. All rights reserved.
//

import Foundation
import MapKit

//whenever you are working with annotations you need to create a custom annotation class for it, it lets you do unique things and its important

var PokemonsNamesArray = [ "Bulbasaur","Ivysaur","Venusaur","Charmander","Charmeleon","Charizard",
                 "Squirtle","Wartortle","Blastoise","Caterpie","Metapod","Butterfree",
                 "Weedle","Kakuna","Beedrill","Pidgey","Pidgeotto","Pidgeot","Rattata",
                 "Raticate","Spearow","Fearow","Ekans","Arbok","Pikachu","Raichu",
                 "Sandshrew","Sandslash","Nidoran","Nidorina","Nidoqueen","Nidoran",
                 "Nidorino","Nidoking","Clefairy","Clefable","Vulpix","Ninetales",
                 "Jigglypuff","Wigglytuff","Zubat","Golbat","Oddish","Gloom",
                 "Vileplume","Paras","Parasect","Venonat","Venomoth","Diglett","Dugtrio",
                 "Meowth","Persian","Psyduck","Golduck","Mankey","Primeape","Growlithe",
                 "Arcanine","Poliwag","Poliwhirl","Poliwrath","Abra","Kadabra","Alakazam",
                 "Machop","Machoke","Machamp","Bellsprout","Weepinbell","Victreebel",
                 "Tentacool","Tentacruel","Geodude","Graveler","Golem","Ponyta","Rapidash",
                 "Slowpoke","Slowbro","Magnemite","Magneton","Farfetch'd","Doduo","Dodrio",
                 "Seel","Dewgong","Grimer","Muk","Shellder","Cloyster","Gastly","Haunter",
                 "Gengar","Onix","Drowzee","Hypno","Krabby","Kingler","Voltorb","Electrode",
                 "Exeggcute","Exeggutor","Cubone","Marowak","Hitmonlee","Hitmonchan",
                 "Lickitung","Koffing","Weezing","Rhyhorn","Rhydon","Chansey","Tangela",
                 "Kangaskhan","Horsea","Seadra","Goldeen","Seaking","Staryu","Starmie",
                 "Mr. Mime","Scyther","Jynx","Electabuzz","Magmar","Pinsir","Tauros","Magikarp",
                 "Gyarados","Lapras","Ditto","Eevee","Vaporeon","Jolteon","Flareon","Porygon",
                 "Omanyte","Omastar","Kabuto","Kabutops","Aerodactyl","Snorlax","Articuno",
                 "Zapdos","Moltres","Dratini","Dragonair","Dragonite","Mewtwo","Mew" ]
var PokemonsArray = [Pokemon]()


class PokeAnnotation: NSObject, MKAnnotation {
    //this protocol we have to implement variables not conform to functions, and needs initializer
    
    var coordinate = CLLocationCoordinate2D() //this || initialized just incase
    var pokemonNumber: Int
    var pokemonName: String
    var title: String? //this
    
    //title comes from annotation itself not from our code
    
    init(coordinate: CLLocationCoordinate2D, pokemonNumber: Int) {
        self.coordinate = coordinate
        self.pokemonNumber = pokemonNumber
        self.pokemonName = PokemonsNamesArray[pokemonNumber-1] //pokemonIds starts from 1 and arrays starts from 0
        self.title = self.pokemonName
    }
    
}
