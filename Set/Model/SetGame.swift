//
//  PlayingSet.swift
//  Set
//
//  Created by Alexander Angelov on 15.10.22.
//

import Foundation

//MARK: Delegate
protocol SetGameDelegate: AnyObject {
    func setGameDidUpdateCards(_ setGame: SetGame)
    func setGameDidUpdatePoints(_ setGame: SetGame)
    func setGameDidEnd(_ setGame: SetGame)
    func setGameDidEnableDealButton(_ setGame: SetGame, isEnabled: Bool)
    func setGameDidShuffleCardsOnField(_ setGame: SetGame, indices: [Int])
    func setGameDidPrepareNewGame(_ setGame: SetGame)
    func setGameDidFindHint(_ setGame: SetGame, at indices: [Int])
    
    func setGame(_ setGame: SetGame, didSelectCardAt index: Int)
    func setGame(_ setGame: SetGame, didCardsMatch isMatched: Bool, at indices: [Int])
}

class SetGame {
    
    //MARK: properties
    private var deck: [Card] = []
    private(set) var selectedCardsIndices: [Int] = []
    private(set) var dealtCards: [Card] = []
    weak var delegate: SetGameDelegate?
    
    private(set) var points = 0 {
        didSet {
            delegate?.setGameDidUpdatePoints(self)
        }
    }
    
    //MARK: Methods
    func selectCard(at index: Int) {
        if !selectedCardsIndices.contains(index) {
            selectedCardsIndices.append(index)
            makeASetIfPossible()
        }
        replaceMatchedCards()
        
        if isGameEnded() {
            delegate?.setGameDidEnd(self)
        }
    }
    
    func isSelected(at index: Int) -> Bool {
        return selectedCardsIndices.contains(index)
    }
    
    func deselectCard(at index: Int) {
        if selectedCardsIndices.count != 3 {
            selectedCardsIndices.removeAll(where: { $0 == index })
        } else {
            if checkIfCardsMatch(indices: selectedCardsIndices) {
                replaceCards(at: selectedCardsIndices)
                selectedCardsIndices.removeAll()
            } else {
                delegate?.setGameDidUpdateCards(self)
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
        
        delegate?.setGameDidUpdateCards(self)
        delegate?.setGameDidPrepareNewGame(self)
    }
    
    func dealThreeCards() {
        guard deck.count >= 3 else {
            return
        }
        for _ in 0..<3 {
            let card = deck.removeFirst()
            dealtCards.append(card)
        }
        delegate?.setGameDidUpdateCards(self)
        delegate?.setGameDidEnableDealButton(self, isEnabled: !deck.isEmpty)
    }
    
    func shuffleCardsOnField() {
        selectedCardsIndices.removeAll()
        dealtCards.shuffle()
        delegate?.setGameDidShuffleCardsOnField(self, indices: [])
    }
    
    func findSetOnTheField() {
        guard let indices = lookForASet() else {
            return
        }
        delegate?.setGameDidFindHint(self, at: indices)
    }
}

//MARK: Private Methods
private extension SetGame {
    
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
    
    private func checkIfCardsMatch(indices: [Int]) -> Bool {
        guard indices.count == 3 else {
            return false
        }
        return getMatchState(of: getCards(from: indices))
    }
    
    private func dealCards(_ count: Int) {
        for _ in 0..<count {
            if !deck.isEmpty {
                dealtCards.append(deck.removeFirst())
            } else {
                break
            }
        }
    }
    
    private func createDeck() -> [Card] {
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
    
    private func makeASetIfPossible() {
        guard selectedCardsIndices.count == 3 else {
            return
        }
        if checkIfCardsMatch(indices: selectedCardsIndices) {
            points += 3
        } else {
            points -= 5
        }
        delegate?.setGame(self, didCardsMatch: checkIfCardsMatch(indices: selectedCardsIndices), at: selectedCardsIndices)
    }
    
    private func getCards(from indices: [Int]) -> [Card] {
        let cards:[Card] = indices.map { index in
            dealtCards[index]
        }
        return cards
    }
    
    private func lookForASet() -> [Int]? {
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
    
    private func moveBackIndex(_ index: inout Int) {
        guard deck.isEmpty else {
            return
        }
        let originalIndex = index
        for selectedCardIndex in selectedCardsIndices {
            if originalIndex > selectedCardIndex {
                index -= 1
            }
        }
    }
    
    private func replaceCards(at indices: [Int]) {
        if deck.isEmpty {
            dealtCards.remove(at: indices)
        } else {
            for index in indices {
                dealtCards[index] = deck.removeFirst()
            }
        }
        delegate?.setGameDidUpdateCards(self)
    }
    
    private func replaceMatchedCards() {
        guard selectedCardsIndices.count > 3 else {
            return
        }
        var lastSelectedCardIndex = selectedCardsIndices.removeLast()
        if checkIfCardsMatch(indices: selectedCardsIndices) {
            moveBackIndex(&lastSelectedCardIndex)
            replaceCards(at: selectedCardsIndices)
        } else {
            delegate?.setGameDidUpdateCards(self)
        }
        delegate?.setGame(self, didSelectCardAt: lastSelectedCardIndex)
        selectedCardsIndices = [lastSelectedCardIndex]
    }
    
    private func isGameEnded() -> Bool {
        if deck.isEmpty && lookForASet() == nil {
            return true
        }
        return false
    }
}
