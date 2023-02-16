//
//  DeckView.swift
//  Set
//
//  Created by Alexander Angelov on 15.02.23.
//

import UIKit

class DeckView: UIImageView {
    
    var label: UILabel?
    
    enum State {
        case notEmpty
        case empty
        
        var text: String {
            switch self {
                case .notEmpty:
                    return "Deal 3"
                case .empty:
                    return ""
            }
        }
        
        var image: UIImage? {
            switch self {
                case .notEmpty:
                    return UIImage(named: "cardBack")
                case .empty:
                    return nil
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
        label?.textColor = .red
        label?.textAlignment = .center
        label?.font = .systemFont(ofSize: 25, weight: .bold)
        addSubview(label!)
    }
}
