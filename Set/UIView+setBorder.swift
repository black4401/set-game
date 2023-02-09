//
//  UIView+setBorder.swift
//  Set
//
//  Created by Alexander Angelov on 9.02.23.
//

import UIKit

extension UIView {
    func setBorder(borderWidth: CGFloat, borderColor: UIColor) {
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
    }
}
