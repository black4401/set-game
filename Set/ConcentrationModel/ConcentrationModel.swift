//
//  ConcentrationModel.swift
//  ConcentrationGame
//
//  Created by Alexander Angelov on 20.09.22.
//

import Foundation

class ConcentrationModel {
    
    private(set) var cards: [ConcentrationCard] = []
    private(set) var points = 0
    private(set) var flips = 0
    
    private var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
            return cards.indices.filter{cards[$0].isFaceUp}.oneAndOnly
        }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    func newGame() {
        for index in cards.indices {
            cards[index].isFaceUp = false
            cards[index].isMatched = false
            points = 0
            flips = 0
        }
        shuffleCards()
        for index in cards.indices {
            cards[index].wasFlipped = false
        }
    }
    
    func chooseCard(at index: Int){
        if !cards[index].isMatched {
            flips += 1
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                if cards[matchIndex] == cards[index] {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                    points += 2
                } else {
                    if cards[index].wasFlipped {
                        points -= 1
                    }
                    
                    if cards[matchIndex].wasFlipped {
                        points -= 1
                    }
                }
                
                cards[index].isFaceUp = true
                cards[index].wasFlipped = true
                cards[matchIndex].wasFlipped = true
            } else{
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
    }
    
    init(numberOfPairsOfCards: Int){
        for _ in 1...numberOfPairsOfCards {
            let card = ConcentrationCard()
            cards += [card, card]
        }
        shuffleCards()
    }
    func shuffleCards(){
        cards.shuffle()
    }
}

extension Collection {
    var oneAndOnly: Element? {
        return count == 1 ? first : nil
    }
}
