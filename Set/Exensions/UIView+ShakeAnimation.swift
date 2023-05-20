//
//  UIView+ShakeAnimation.swift
//  Set
//
//  Created by Alexander Angelov on 17.02.23.
//

import UIKit

extension UIView {
    
    func shake() {
        let animation = CABasicAnimation()
        animation.duration = 0.04
        animation.repeatCount = 5
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPointMake(self.center.x - 15.0, self.center.y))
        animation.toValue = NSValue(cgPoint: CGPointMake(self.center.x + 15.0, self.center.y))
        self.layer.add(animation, forKey: "position")
    }
}
