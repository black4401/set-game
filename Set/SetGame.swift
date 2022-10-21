//
//  PlayingSet.swift
//  Set
//
//  Created by Alexander Angelov on 15.10.22.
//

import Foundation

struct SetGame {
    private var deck: [Card] = []
    private(set) var dealtCards: [Card] = []
    
    var noCardsInDeck: Bool {
        deck.count == 0
    }
    
    private var selectedCards: [Card] {
        dealtCards.filter { card in
            card.isSelected
        }
    }
    
    mutating func startNewGame() {
        deck = createDeck().shuffled()
        dealtCards.removeAll()
        
        dealCard(12)
    }
    
    mutating func chooseCard(card: Card) {
        let state: SetGame.Card.MatchState = .Match //getMatchState(of: selectedCards) //uncomment to play correctly
        switch state {
            case .Match:
                replace(cards: selectedCards)
            case .MissMatch:
                deSelect(cards: selectedCards)
            default:
                break
        }
        
        if let cardIndex = dealtCards.firstIndex(matching: card) {
            dealtCards[cardIndex].isSelected = !dealtCards[cardIndex].isSelected
            
            let state = getMatchState(of: selectedCards)
            changeMatchState(of: selectedCards, to: state)
        }
    }
    
    mutating func dealExtraCards(_ count: Int) {
        if getMatchState(of: selectedCards) == .Match {
            replace(cards: selectedCards)
        } else {
            dealCard(count)
        }
    }
    
    private mutating func dealCard(_ count: Int) {
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
    
    private mutating func replace(cards: [Card]) {
        for card in cards {
            if let cardIndex = self.dealtCards.firstIndex(matching: card) {
                if let replaceCard = deck.popLast() {
                    self.dealtCards[cardIndex] = replaceCard
                } else {
                    self.dealtCards.remove(at: cardIndex)
                }
            }
        }
    }
    
    private mutating func deSelect(cards: [Card]) {
        for card in cards {
            if let cardIndex = self.dealtCards.firstIndex(matching: card) {
                self.dealtCards[cardIndex].isSelected = false
                self.dealtCards[cardIndex].isMatch = .NotSetYet
            }
        }
    }
    
    private mutating func changeMatchState(of cards: [Card], to state: Card.MatchState) {
        for card in cards {
            if let cardIndex = self.dealtCards.firstIndex(matching: card) {
                self.dealtCards[cardIndex].isMatch = state
            }
        }
    }
    
    struct Card: Identifiable { // move to separate
        var id: Int
        
        var isSelected: Bool = false
        var isMatch: MatchState = .NotSetYet
        
        let numberOfShapes: NumberOfShapes
        let shape: Shape
        let color: Color
        let shading: Shading
        
        enum MatchState {
            case Match, MissMatch, NotSetYet
        }
        
        enum NumberOfShapes: Int, CaseIterable {
            case one = 1, two = 2, three = 3
        }
        enum Shape: CaseIterable {
            case triangle, square, oval
        }
        enum Color: CaseIterable {
            case red, blue, purple
        }
        enum Shading: CaseIterable {
            case filled, striped, empty
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


