//
//  Collection+oneAndOnly.swift
//  Set
//
//  Created by Alexander Angelov on 8.03.23.
//

extension Collection {
    var oneAndOnly: Element? {
        return count == 1 ? first : nil
    }
}
