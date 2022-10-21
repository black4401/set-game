//
//  PlayingSet.swift
//  Set
//
//  Created by Alexander Angelov on 15.10.22.
//

import Foundation
import UIKit

class PlayingSet {
    
    private(set) var points = 0
    var deck: [Card] = []
    var cardsOnTheField: [Card] = []
    var discardedCards: [Card] = []
    var cardsCurrentlySelected: [Card] = []
    var deckNotEmpty : Bool {
        return deck.count != 0
    }
    
    func deselectAllCards(){
        for card in cardsCurrentlySelected {
            card.isSelected   = false
        }
    }
    
    func chooseCard(card: Card) -> [Int]? {
        var indexesToReplace: [Int] = []
        if(cardsCurrentlySelected.count < 3){
            
            if(cardsCurrentlySelected.count == 3){
                if(setMatchCards(card1: cardsCurrentlySelected[0], card2: cardsCurrentlySelected[1], card3: cardsCurrentlySelected[2])){
                    
                    cardsCurrentlySelected.forEach { card in
                        indexesToReplace.append(card.indexOnField)
                        discardedCards.append(card)
                        points += 1
                        
                        if(deckNotEmpty){
                            replaceMatchedCards()
                        }else{
                            print("Deck is empty")
                        }
                    }
                }else{
                    points -= 5
                    cardsCurrentlySelected.forEach { card in
                        card.isSelected = false
                    }
                    cardsCurrentlySelected.removeAll()
                }
            } else {
                if cardsCurrentlySelected.contains(where: {$0.id == card.id}){
                    if cardsCurrentlySelected.contains(where: {$0.indexOnField == card.indexOnField}) {
                        card.isSelected = false
                        cardsCurrentlySelected.removeAll(where: {$0.id == card.id})
                    }
                }
                else {
                    card.isSelected = true
                    cardsCurrentlySelected.append(card)
                }
            }
        }
        return indexesToReplace
    }
    
    private func createDeck() { // add one of each type of cards to the deck and consecutive IDs
        var cardID = 0
        for shape in Card.Shape.allCases{
            for elementCount in Card.ElementCount.allCases {
                for color in Card.Color.allCases {
                    for shading in Card.Shading.allCases {
                        deck.append(Card(id: cardID, color: color, shading: shading, shape: shape, elementCount: elementCount))
                        cardID = cardID + 1
                    }
                }
            }
        }
    }
    
    func dealCard() -> Card {
        if !deck.isEmpty {
            cardsOnTheField.append(deck.first!)
            return deck.removeFirst()
            
        } else {
            return deck.removeFirst()
        }
    }
    
    func replaceMatchedCards(){
        cardsCurrentlySelected.forEach{ card in
            if deckNotEmpty {
                var newCard = deck.first!
                newCard.indexOnField = card.indexOnField
                cardsOnTheField.append(newCard)
            } else {
                print("Deck is empty")
            }
        }
    }
    
    func deselectAll(){
        cardsCurrentlySelected.forEach({$0.isSelected = false})
    }
    
    func setMatchCards(card1: Card, card2: Card, card3: Card) -> Bool {
        
        let numbersAllMatch : Bool  = (card1.elementCount == card2.elementCount && card2.elementCount == card2.elementCount)
        let numbersAllDiffer : Bool = (card1.elementCount != card2.elementCount && card2.elementCount != card3.elementCount && card1.elementCount != card3.elementCount)
        
        let colorsAllMatch : Bool  = (card1.color == card2.color && card2.color == card3.color)
        let colorsAllDiffer : Bool = (card1.color != card2.color && card2.color != card3.color && card1.color != card3.color)
        
        let shapesAllMatch : Bool  = (card1.shape == card2.shape && card2.shape == card3.shape)
        let shapesAllDiffer : Bool = (card1.shape != card2.shape && card2.shape != card3.shape && card1.shape != card3.shape)
        
        let shadingsAllMatch : Bool  = (card1.shading == card2.shading && card2.shading == card3.shading)
        let shadingsAllDiffer : Bool = (card1.shading != card2.shading && card2.shading != card3.shading && card1.shading != card3.shading)
        
        return (numbersAllMatch || numbersAllDiffer) && (colorsAllMatch || colorsAllDiffer) && (shapesAllMatch || shapesAllDiffer) && (shadingsAllMatch || shadingsAllDiffer)
    }
    
    func shuffleDeck() {
        deck.shuffle()
    }
    
    init() {
        createDeck()
        shuffleDeck()
    }
    
    //    enum Color : CaseIterable {
    //        case red
    //        case blue
    //        case purple
    //    }
    //    enum Shading : CaseIterable {
    //        case filled
    //        case striped
    //        case empty
    //    }
    //
    //    enum Shape : CaseIterable {
    //        case oval
    //        case triangle
    //        case square
    //    }
    //    enum ElementCount : CaseIterable {
    //        case one
    //        case two
    //        case three
    //    }
    
    //    class Card : Identifiable, Hashable {
    //
    //        var isSelected : Bool = false
    //        var indexOnField: Int = 0
    //        var id: Int = 0
    //        var color: Color = .red
    //        var shading: Shading = .striped
    //        var shape: Shape = .triangle
    //        var elementCount: ElementCount = .one
    //
    //        static func == (lhs: PlayingSet.Card, rhs: PlayingSet.Card) -> Bool {
    //            lhs.id == rhs.id
    //        }
    //        func hash(into hasher: inout Hasher) {
    //            hasher.combine(id)
    //        }
    //
    //        init() {
    //
    //        }
    //        init(id: Int, color: Color, shading: Shading, shape: Shape, elementCount: ElementCount) {
    //            self.id = id
    //            self.color = color
    //            self.shading = shading
    //            self.shape = shape
    //            self.elementCount = elementCount
    //        }
    //
    //        func getColor() -> UIColor {
    //            switch color {
    //                case .red:
    //                    return UIColor.red
    //                case .blue:
    //                    return UIColor.blue
    //                case .purple:
    //                    return UIColor.purple
    //            }
    //        }
    //        func getShape() -> String {
    //            switch shape {
    //                case .triangle:
    //                    return "▲"
    //                case .oval:
    //                    return "●"
    //                case .square:
    //                    return "■"
    //            }
    //        }
    //        func getCount() -> Int {
    //            switch elementCount {
    //                case .one:
    //                    return 1
    //                case .two:
    //                    return 2
    //                case .three:
    //                    return 3
    //            }
    //        }
    //        func buildAttributedString() -> NSAttributedString {
    //            let string = buildString(count: getCount(), shape: getShape())
    //            let attributes = colorShadeAttributes(color: getColor())
    //
    //            return NSAttributedString(string: string, attributes: attributes)
    //        }
    //
    //        func buildString(count: Int, shape: String) -> String {
    //            var result = ""
    //            for _ in 1...count {
    //                result.append(shape)
    //                result.append("\n")
    //            }
    //            return result
    //        }
    //
    //        func colorShadeAttributes(color: UIColor) -> [NSAttributedString.Key : Any] {
    //            switch shading {
    //                case .filled:
    //                    return [
    //                        .strokeWidth : -1.0,
    //                        .foregroundColor : color.withAlphaComponent(1),
    //                        .font: UIFont.boldSystemFont(ofSize: 30)]
    //                case .empty:
    //                    return [
    //                        .strokeWidth : 10.0,
    //                        .foregroundColor : color.withAlphaComponent(1),
    //                        .font: UIFont.boldSystemFont(ofSize: 30)]
    //                case .striped:
    //                    return [
    //                        .strokeWidth : -1.0,
    //                        .foregroundColor : color.withAlphaComponent(0.15),
    //                        .font: UIFont.boldSystemFont(ofSize: 30)]
    //            }
    //        }
    //    }
}

extension Collection where Element: Identifiable {
    func first(matching: Element) -> Element! {
        for element in self{
            if element.id == matching.id {
                return element
            }
        }
        return nil
    }
}


