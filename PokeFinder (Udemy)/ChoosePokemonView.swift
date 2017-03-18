//
//  ChoosePokemonView.swift
//  PokeFinder (Udemy)
//
//  Created by Mahmoud Hamad on 2/11/17.
//  Copyright © 2017 Mahmoud SMGL. All rights reserved.
//

import UIKit

class ChoosePokemonView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var inSearchMode = false
    
    var filteredPokemons = [Pokemon]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        print("Choose Pokemon AwakeFromNib")
        
        layer.masksToBounds = true
        layer.cornerRadius = 12.0
        
        searchBar.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == "" || searchBar.text == nil {
            inSearchMode = false
            collectionView.reloadData()
            self.endEditing(true)
        } else {
            inSearchMode = true
            
            var lower = searchBar.text!.lowercased() // "!" because we checked its not nil
            
            filteredPokemons = PokemonsArray.filter({ $0.pokeName.range(of: lower) != nil })
            //$0 = pokemon
            
            collectionView.reloadData()
            print("TextDidBeginEditing")
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("collectionView didSelectItemAt  IndexPath: \(indexPath.row)")
        
        var selectedPokemonIndex = 0
        
        if inSearchMode {

            selectedPokemonIndex = filteredPokemons[indexPath.row].pokeId
            
        } else { selectedPokemonIndex = PokemonsArray[indexPath.row].pokeId }
        //selectedPokemonIndex = indexPath.row + 1
        
        var selected = inSearchMode ? filteredPokemons[indexPath.row].pokeId : PokemonsArray[indexPath.row].pokeId
        
        //if inSearchMode is true then do 1st one if its false do 2nd one
        
        if let MainVC = parentViewController as? MainVC {
            self.isHidden = true
            MainVC.BlurEffect.effect = nil
            MainVC.BlurEffect.isHidden = true
            print("didSelectItemAt if")
            
            self.endEditing(true)
            MainVC.createSighting(withPokemon: selected)
        } else {
            print("didSelectItemAt else")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: C.ChoosePokemonCellIdentifier, for: indexPath) as? ChoosePokemonCell {
            
            var pokemon: Pokemon
            
            if inSearchMode {
                pokemon = filteredPokemons[indexPath.row]
            } else {
                pokemon = PokemonsArray[indexPath.row]
            }
            
            cell.configuerCell(Poke: pokemon)
            print(indexPath.row)
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if inSearchMode {
            return filteredPokemons.count
        } else {
            return PokemonsArray.count
        }
    }
        
    @IBAction func DismissPressed(_ sender: Any) {
        if let MainVC = parentViewController as? MainVC {
            self.isHidden = true
            MainVC.BlurEffect.effect = nil
            MainVC.BlurEffect.isHidden = true
            print("Dismiss if")
        } else {
            print("Dismiss else")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 105, height: 120)
    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
}
