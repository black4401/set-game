//
//  DeckView.swift
//  Set
//
//  Created by Alexander Angelov on 15.02.23.
//

import UIKit

class DeckView: UIImageView {
    
    var label: UILabel?
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
    
    func configureDiscardPileLabel() {
        label = UILabel()
        label?.text = "Discard"
        label?.textColor = .black
        label?.textAlignment = .center
        label?.font = .systemFont(ofSize: 25, weight: .bold)
        addSubview(label!)
    }
}
