//
//  CardGridView.swift
//  Set
//
//  Created by Alexander Angelov on 6.02.23.
//

import UIKit

class CardGridView: UIView {
    
    private var cardViews: [CardView] = []
    
    func updateCardViews(with cards: [Card]) {
        for cardView in cardViews {
            cardView.removeFromSuperview()
        }
        
        cardViews = []
        var grid = Grid(layout: .aspectRatio(CardViewConstant.aspectRatio), frame: bounds)
        grid.cellCount = cards.count
        
        for (index, card) in cards.enumerated() {
            guard let cardFrame = grid[index] else {
                return
            }
            let inset = cardFrame.width * CardViewConstant.insetMultiplier
            let frame = cardFrame.insetBy(dx: inset, dy: inset)
            let cardView = CardView(frame: frame)
            cardView.configure(with: card)
            addSubview(cardView)
            cardViews.append(cardView)
        }
    }
    
    func updateCardViewBorder(at index: Int, to color: UIColor) {
        cardViews[index].setBorder(borderWidth: CardViewConstant.borderWidth, borderColor: color)
    }
    
    func removeCardViewBorder(at index: Int) {
        cardViews[index].setBorder(borderWidth: CardViewConstant.borderWidth, borderColor: .white)
    }
    
    func updateCardViewBackground(at index: Int, to color: UIColor) {
        cardViews[index].backgroundColor = color
    }
    
    func getIndex(of cardView: CardView) -> Int? {
        return cardViews.firstIndex(where: { $0 == cardView })
    }
}

