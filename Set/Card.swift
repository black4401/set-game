//
//  Card.swift
//  ConcentrationGame
//
//  Created by Alexander Angelov on 20.09.22.
//

import Foundation


struct ConcentrationCard: Hashable
{
    func hash(into hasher: inout Hasher) {
            hasher.combine(identifier)
        }
   
    static func == (lhs: ConcentrationCard, rhs: ConcentrationCard) -> Bool {
      return lhs.identifier == rhs.identifier
    }
    
    var wasFlipped = false
    var isFaceUp = false
    var isMatched = false
    private var identifier: Int
    
    private static var identifierFactory = 0
    private static func getIdentifier() -> Int{
        identifierFactory += 1
        return identifierFactory
    }
    
    init(){
        self.identifier = ConcentrationCard.getIdentifier()
    }
    
}
