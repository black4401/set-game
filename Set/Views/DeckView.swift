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
                configure()
            } else {
                image = nil
            }
        }
    }
    
    func configure() {
        layer.cornerRadius = CardViewConstant.cornerRadius
        layer.masksToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
        isUserInteractionEnabled = true
    }
}
