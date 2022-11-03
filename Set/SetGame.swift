//
//  PlayingSet.swift
//  Set
//
//  Created by Alexander Angelov on 15.10.22.
//

import Foundation

class SetGame {
    private var deck: [Card] = []
    private(set) var dealtCards: [Card] = []
    private(set) var points = 0
    
    private var selectedCards: [Card] {
        dealtCards.filter({$0.isSelected == true})
    }
    
    func startNewGame() {
        deck = createDeck().shuffled()
        dealtCards.removeAll()
        points = 0
        dealCards(12)
    }
    
    func checkIfCardsMatch() {
        
        guard selectedCards.count == 3 else {
            print("selected cards are not 3")
            return
        }
        let state: Card.MatchState = getMatchState(of: selectedCards)
        switch state {
            case .Match:
                points += 3
                replace(cards: selectedCards)
            case .MissMatch:
                points -= 5
                deSelect(cards: selectedCards)
            default:
                break
        }
    }
    
    func invertMatchState(card: Card) {
        guard let cardIndex = dealtCards.firstIndex(matching: card) else {
            return
        }
        dealtCards[cardIndex].isSelected = !dealtCards[cardIndex].isSelected
        
        let state = getMatchState(of: selectedCards)
        changeMatchState(of: selectedCards, to: state)
    }
    
    func dealExtraCards(_ count: Int) {
        guard dealtCards.count < 24 else {
            print("selected cards are not 3")
            return
        }
        if getMatchState(of: selectedCards) == .Match {
            replace(cards: selectedCards)
        } else {
            dealCards(count)
        }
    }
    
    private func dealCards(_ count: Int) {
        for _ in 0..<count {
            if let card = deck.popLast() {
                dealtCards.append(card)
            } else {
                break
            }
        }
    }
    
    private func createDeck() -> [Card] {
        var cards: [Card] = []
        var id = 0
        for numberOfShape in Card.NumberOfShapes.allCases {
            for shape in Card.Shape.allCases {
                for color in Card.Color.allCases {
                    for shading in Card.Shading.allCases {
                        let card = Card(id: id, numberOfShapes: numberOfShape, shape: shape, color: color, shading: shading)
                        id += 1
                        cards.append(card)
                    }
                }
            }
        }
        return cards
    }
    
    private func getMatchState(of cards: [Card]) -> Card.MatchState {
        
        if cards.count != 3 {
            return .NotSetYet
        }
        
        let uniqueNumberOfShapes = Set(cards.map { card in card.numberOfShapes })
        if (uniqueNumberOfShapes.count == 2) {
            return .MissMatch
        }
        
        let uniqueShapes = Set(cards.map { card in card.shape })
        if (uniqueShapes.count == 2) {
            return .MissMatch
        }
        
        let uniqueColors = Set(cards.map { card in card.color })
        if uniqueColors.count == 2 {
            return .MissMatch
        }
        
        let uniqueShadings = Set(cards.map { card in card.shading })
        if uniqueShadings.count == 2 {
            return .MissMatch
        }
        return .Match
    }
    
    private  func replace(cards: [Card]) {
        for card in cards {
            if let cardIndex = dealtCards.firstIndex(matching: card) {
                if let replaceCard = deck.popLast() {
                    dealtCards[cardIndex] = replaceCard
                } else {
                    dealtCards.remove(at: cardIndex)
                }
            }
        }
    }
    
    private  func deSelect(cards: [Card]) {
        for card in cards {
            if let cardIndex = dealtCards.firstIndex(matching: card) {
                dealtCards[cardIndex].isSelected = false
                dealtCards[cardIndex].isMatch = .NotSetYet
            }
        }
    }
    
    private  func changeMatchState(of cards: [Card], to state: Card.MatchState) {
        for card in cards {
            if let cardIndex = dealtCards.firstIndex(matching: card) {
                dealtCards[cardIndex].isMatch = state
            }
        }
    }
}

extension Array where Element: Identifiable {
    func firstIndex(matching: Element) -> Int? {
        for index in 0..<self.count {
            if self[index].id == matching.id {
                return index
            }
        }
        return nil
    }
}


