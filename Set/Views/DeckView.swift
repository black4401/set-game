//
//  DeckView.swift
//  Set
//
//  Created by Alexander Angelov on 15.02.23.
//

import UIKit

class DeckView: UIImageView {
    
    func removeCardBack() {
        self.image = nil
    }
    
    func setUpCardBack() {
        image = UIImage(named: "cardBack")
    }
    
    func setCornerRadius() {
        layer.cornerRadius = CardViewConstant.cornerRadius
        layer.masksToBounds = true
    }
    
    func configure() {
        setCornerRadius()
        translatesAutoresizingMaskIntoConstraints = false
        isUserInteractionEnabled = true
    }
}
