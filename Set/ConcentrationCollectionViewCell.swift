//
//  ConcentrationCollectionViewCell.swift
//  Set
//
//  Created by Alexander Angelov on 2.03.23.
//

import UIKit

class ConcentrationCollectionViewCell: UICollectionViewCell {
    

    @IBOutlet weak var label: UILabel! {
        didSet {
            label.font = UIFont.systemFont(ofSize: bounds.size.width / 2)
        }
    }
    
    func configure(text: String, backgroundColor: UIColor) {
        label.text = text
        self.backgroundColor = backgroundColor
    }
    
}
