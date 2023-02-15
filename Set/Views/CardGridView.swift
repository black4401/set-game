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
        let difference = cards.count - cardViews.count
        var oldFrames: [CGRect] = []
        for cardView in cardViews {
            cardView.removeFromSuperview()
            oldFrames.append(cardView.frame)
        }
        cardViews = []
        var grid = Grid(layout: .aspectRatio(CardViewConstant.aspectRatio), frame: bounds)
        grid.cellCount = cards.count
        var iterations = 1.0
        for (index, card) in cards.enumerated() {
            guard let cardFrame = grid[index] else {
                return
            }
            let inset = cardFrame.width * CardViewConstant.insetMultiplier
            let frame = cardFrame.insetBy(dx: inset, dy: inset)
            let cardView = CardView(frame: frame)
            
            if index < cards.count - difference {
                cardView.frame = oldFrames[index]
                UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.5, delay: 0, animations: {
                    cardView.frame = frame
                })
            } else {
                cardView.frame = frame
                cardView.showBackSide()
                cardView.alpha = 0
                UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.5, delay: iterations/5.0, animations: {
                    cardView.frame = frame
                    cardView.alpha = 1
                }) { _ in
                    UIView.transition(with: cardView, duration: 0.2, options: .transitionFlipFromLeft, animations: {
                        cardView.removeBackSide()
                    })
                }
                iterations += 1
            }
            
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

