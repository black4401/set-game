//
//  PlayingSet.swift
//  Set
//
//  Created by Alexander Angelov on 15.10.22.
//

import Foundation

protocol SetGameDelegate: AnyObject {
    func updateCardsOnField(_ setGame: SetGame)
    func setGameUpdateCards(_ setGame: SetGame)
    
    func setGame(_ setGame: SetGame, didSelectCardAt index: Int)
    
}

class SetGame {
    private var deck: [Card] = []
    private(set) var dealtCards: [Card] = []
    private(set) var points = 0
    private(set) var selectedCardsIndices: [Int] = []
    private(set) var cardsOnField: [Card] = []
    
    weak var delegate: SetGameDelegate?
    
    private var selectedCards: [Card] {
        dealtCards.filter({$0.isSelected == true})
    }
    
    func selectCard(at index: Int) {
        if !selectedCardsIndices.contains(index) {
            selectedCardsIndices.append(index)
            
        }
        if checkIfCardsMatch() && selectedCardsIndices.count == 3 {
            replaceCards(at: selectedCardsIndices)
            //replace(cards: selectedCards)
            selectedCardsIndices.removeAll()
        }
    }
    
    func deselectCard(at index: Int) {
        if selectedCardsIndices.count != 3 {
            selectedCardsIndices.removeAll(where: { $0 == index })
            // do score
        } else {
            if checkIfCardsMatch() {
                replaceCards(at: selectedCardsIndices)
                selectedCardsIndices.removeAll()
            } else {
                delegate?.updateCardsOnField(self)
                selectedCardsIndices = [index]
                //delegate?.setGame(self, didSelectCardAt: index)
            }
        }
    }
    

    
    func checkIfCardsMatch() -> Bool {
        guard selectedCards.count == 3 else {
            print("Less than 3 cards selected!")
            return false
        }
        return getMatchState(of: getCards(from: selectedCardsIndices))
    }
    
    func getCards(from indices: [Int]) -> [Card] {
        var cards:[Card] = []
        for index in indices {
            cards.append(cardsOnField[index])
        }
        return cards
    }
    
    func startNewGame() {
        deck = createDeck().shuffled()
        cardsOnField.removeAll()
        points = 0
        dealCards(12)
    }
    
//    func checkIfCardsMatch() {
//
//        guard selectedCards.count == 3 else {
//            print("selected cards are not 3")
//            return
//        }
//        let state: Card.MatchState = getMatchState(of: selectedCards)
//        switch state {
//            case .Match:
//                points += 3
//                replace(cards: selectedCards)
//            case .MissMatch:
//                points -= 5
//                deSelect(cards: selectedCards)
//            default:
//                break
//        }
//    }
    
//    func invertMatchState(card: Card) {
//        guard let cardIndex = dealtCards.firstIndex(matching: card) else {
//            return
//        }
//        dealtCards[cardIndex].isSelected = !dealtCards[cardIndex].isSelected
//
//        let state = getMatchState(of: selectedCards)
//        changeMatchState(of: selectedCards, to: state)
//    }
    
    func dealThreeCards() {
        guard deck.count >= 3 else {
            return
        }
        for _ in 0..<3 {
            cardsOnField.append(deck.removeFirst())
        }
        delegate?.setGameUpdateCards(self)
    }
    
    private func dealCards(_ count: Int) {
        for _ in 0..<count {
            if let card = deck.popLast() {
                cardsOnField.append(card)
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
    
    private func getMatchState(of cards: [Card]) -> Bool {
        
        if cards.count != 3 {
            print("Less than 3 cards selected")
            return false
        }
        
        let uniqueNumberOfShapes = Set(cards.map { card in card.numberOfShapes })
        if (uniqueNumberOfShapes.count == 2) {
            return false
        }
        
        let uniqueShapes = Set(cards.map { card in card.shape })
        if (uniqueShapes.count == 2) {
            return false
        }
        
        let uniqueColors = Set(cards.map { card in card.color })
        if uniqueColors.count == 2 {
            return false
        }
        
        let uniqueShadings = Set(cards.map { card in card.shading })
        if uniqueShadings.count == 2 {
            return false
        }
        return true
    }
    
    func replaceCards(at indices: [Int]) {
        if deck.isEmpty {
            cardsOnField.remove(at: indices)
        } else {
            for index in indices {
                cardsOnField[index] = deck.removeFirst()
            }
        }
        //update view
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


