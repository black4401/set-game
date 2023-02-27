//
//  PlayingSet.swift
//  Set
//
//  Created by Alexander Angelov on 15.10.22.
//

import Foundation

protocol SetGameDelegate: AnyObject {
    func setGameUpdateCards(_ setGame: SetGame)
    func setGameUpdatePoints(_ setGame: SetGame)
    func setGameDidEnd(_ setGame: SetGame)
    func setGameEnableDealButton(_ setGame: SetGame, isEnabled: Bool)
    func setGameDidShuffleCardsOnField(_ setGame: SetGame, indices: [Int])
    func setGamePrepareNewGame(_ setGame: SetGame)
    func setGameDidFindHint(_ setGame: SetGame, at indices: [Int])
    func setGameDidReplaceCards(_ game: SetGame)
    func setGameDidRemoveCards(_ game: SetGame)
    
    func setGame(_ setGame: SetGame, didSelectCardAt index: Int)
    func setGame(_ setGame: SetGame, didFindMissmatchAt indices: [Int])
    func setGameDidFindFirstSet(_ setGame: SetGame)
}

class SetGame {
    
    private var deck: [Card] = []
    private(set) var selectedCardsIndices: [Int] = []
    private(set) var dealtCards: [Card] = []
    weak var delegate: SetGameDelegate?
    
    private(set) var points = 0 {
        didSet {
            delegate?.setGameUpdatePoints(self)
        }
    }
    
    func isSelected(at index: Int) -> Bool {
        return selectedCardsIndices.contains(index)
    }
    
    func selectCard(at index: Int) {
        if !selectedCardsIndices.contains(index) {
            selectedCardsIndices.append(index)
            makeASetIfPossible()
        }
        
        if isGameEnded() {
            delegate?.setGameDidEnd(self)
        }
    }
    
    func deselectCard(at index: Int) {
        if selectedCardsIndices.count < 3 {
            selectedCardsIndices.removeAll(where: { $0 == index })
        } else {
            if checkIfCardsMatch(indices: selectedCardsIndices) {
                replaceCards(at: selectedCardsIndices)
                selectedCardsIndices.removeAll()
            } else {
                delegate?.setGameUpdateCards(self)
                selectedCardsIndices.removeAll()
                selectedCardsIndices = [index]
                delegate?.setGame(self, didSelectCardAt: index)
            }
        }
    }
    
    func startNewGame() {
        deck = createDeck()
        dealtCards.removeAll()
        selectedCardsIndices.removeAll()
        points = 0
        deck.shuffle()
        dealCards(12)
        
        delegate?.setGamePrepareNewGame(self)
    }
    
    func dealThreeCards() {
        guard deck.count >= 3 else {
            return
        }
        for _ in 0..<3 {
            dealtCards.append(deck.removeFirst())
        }
        delegate?.setGameUpdateCards(self)
        delegate?.setGameEnableDealButton(self, isEnabled: !deck.isEmpty)
    }
    
    func shuffleCardsOnField() {
        selectedCardsIndices.removeAll()
        dealtCards.shuffle()
        delegate?.setGameDidShuffleCardsOnField(self, indices: [])
    }
    
    func findSetOnTheField() {
        guard let indices = findSetIfAble() else {
            return
        }
        delegate?.setGameDidFindHint(self, at: indices)
    }
}

private extension SetGame {
    
    func createDeck() -> [Card] {
        var cards: [Card] = []
        for numberOfShape in Card.NumberOfShapes.allCases {
            for shape in Card.Shape.allCases {
                for color in Card.Color.allCases {
                    for shading in Card.Shading.allCases {
                        let card = Card(numberOfShapes: numberOfShape, shape: shape, color: color, shading: shading)
                        cards.append(card)
                    }
                }
            }
        }
        return cards
    }
    
    func dealCards(_ count: Int) {
        for _ in 0..<count {
            if let card = deck.popLast() {
                dealtCards.append(card)
            } else {
                break
            }
        }
    }
    
    func replaceCards(at indices: [Int]) {
        if deck.isEmpty {
            dealtCards.remove(at: indices)
            delegate?.setGameDidRemoveCards(self)
        } else {
            for index in indices {
                dealtCards[index] = deck.removeFirst()
            }
            delegate?.setGameDidReplaceCards(self)
        }
    }
    
    func getCards(from indices: [Int]) -> [Card] {
        var cards:[Card] = []
        for index in indices {
            cards.append(dealtCards[index])
        }
        return cards
    }
    
    func isGameEnded() -> Bool {
        if deck.isEmpty && findSetIfAble() == nil {
            return true
        }
        return false
    }
    
    //MARK: Card matching
    func getMatchState(of cards: [Card]) -> Bool {
        
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
    
    func makeASetIfPossible() {
        guard selectedCardsIndices.count == 3 else {
            return
        }
        if checkIfCardsMatch(indices: selectedCardsIndices) {
            points += 3
            replaceCards(at: selectedCardsIndices)
        } else {
            points -= 5
            delegate?.setGame(self, didFindMissmatchAt: selectedCardsIndices)
        }
        selectedCardsIndices.removeAll()
    }
    
    func checkIfCardsMatch(indices: [Int]) -> Bool {
        guard indices.count == 3 else {
            return false
        }
        return getMatchState(of: getCards(from: indices))
    }
    
    func findSetIfAble() -> [Int]? {
        for firstIndex in dealtCards.indices {
            for secondIndex in dealtCards.indices where secondIndex != firstIndex {
                for thirdIndex in dealtCards.indices where thirdIndex != secondIndex {
                    let cardIndices = [firstIndex, secondIndex, thirdIndex]
                    if checkIfCardsMatch(indices: cardIndices) {
                        return cardIndices
                    }
                }
            }
        }
        return nil
    }
}

