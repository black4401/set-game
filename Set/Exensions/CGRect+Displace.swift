//
//  CGRect+Displace.swift
//  Set
//
//  Created by Alexander Angelov on 12.02.23.
//

import Foundation

extension CGRect {
    mutating func displace(in rect: CGRect, count: Int) {
        let height = size.height * CGFloat(count)
        let displacementY = (rect.height - height) / 2
        let transform = CGAffineTransform(translationX: 0, y: displacementY)
        self = self.applying(transform)
    }
}
