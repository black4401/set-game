//
//  Array+RemoveIndices.swift
//  Set
//
//  Created by Alexander Angelov on 9.02.23.
//

import Foundation

extension Array {
    mutating func remove(at indices: [Int]) {
        for index in indices.sorted(by: >) {
            remove(at: index)
        }
    }
}
