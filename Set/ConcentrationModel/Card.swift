//
//  Card.swift
//  ConcentrationGame
//
//  Created by Alexander Angelov on 20.09.22.
//

import Foundation


struct ConcentrationCard: Hashable {
    
    private static var identifierFactory = 0
    private static func getIdentifier() -> Int {
        identifierFactory += 1
        return identifierFactory
    }
    
    private var identifier: Int
    
    var wasFlipped = false
    var isFaceUp = false
    var isMatched = false
    
    init() {
        self.identifier = ConcentrationCard.getIdentifier()
    }
    
    static func == (lhs: ConcentrationCard, rhs: ConcentrationCard) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
}
