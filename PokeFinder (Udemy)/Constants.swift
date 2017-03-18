//
//  Constants.swift
//  PokeFinder (Udemy)
//
//  Created by Mahmoud Hamad on 2/10/17.
//  Copyright © 2017 Mahmoud SMGL. All rights reserved.
//

import Foundation

struct C { //Constants
    
    static let PokemonAnnoIdentifier = "PokemonIdentifier"
    
    static let PokemonDestinationName = "Pokemon Sighting"
    
    static let ChoosePokemonCellIdentifier = "PokemonCell"
    
    
}
extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}
