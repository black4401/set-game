//
//  DeckView.swift
//  Set
//
//  Created by Alexander Angelov on 15.02.23.
//

import UIKit

class DeckView: UIImageView {
    
    var isEmpty: Bool = false {
        didSet {
            if !isEmpty {
                image = UIImage(named: "cardBack")
            } else {
                image = nil
            }
        }
    }
    
    func configure() {
        layer.cornerRadius = CardViewConstant.cornerRadius
        translatesAutoresizingMaskIntoConstraints = false
        isUserInteractionEnabled = true
    }
}
