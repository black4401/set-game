//
//  DeckView.swift
//  Set
//
//  Created by Alexander Angelov on 15.02.23.
//

import UIKit

class DeckView: UIImageView {
    
    var label: UILabel?
    var isEmpty: Bool? {
        didSet {
            if !isEmpty! {
                image = UIImage(named: "cardBack")
            }
        }
    }
    
    func configureDeck() {
        layer.cornerRadius = CardViewConstant.cornerRadius
        translatesAutoresizingMaskIntoConstraints = false
        isUserInteractionEnabled = true
    }
    
    func configureDiscardPile() {
        layer.cornerRadius = CardViewConstant.cornerRadius
        translatesAutoresizingMaskIntoConstraints = false
        isUserInteractionEnabled = false
        label = UILabel()
        label?.text = "Discard"
        label?.textColor = .black
        label?.textAlignment = .center
        label?.font = .systemFont(ofSize: 25, weight: .bold)
        addSubview(label!)
    }
}
