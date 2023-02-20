//
//  CardGridView.swift
//  Set
//
//  Created by Alexander Angelov on 6.02.23.
//

import UIKit

protocol CardGridViewDelegate: AnyObject {
    func cardGridViewDidTapDeck(_ cardGridView: CardGridView)
}

class CardGridView: UIView {
    
    private var cardViews: [CardView] = []
    private var deckView = DeckView()
    private var discardPile = DeckView()
    private var grid: Grid {
        let height = bounds.height - deckView.bounds.height - 20
        let frame = CGRect(x: 0, y: 0, width: bounds.width, height: height)
        let grid = Grid(layout: .aspectRatio(CardViewConstant.aspectRatio), frame: frame)
        return grid
    }
    
    weak var delegate: CardGridViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupDeckView()
        setupDiscardPile()
    }
    
    func dealIntialCardsAnimated(cards: [Card]) {
        var oldFrames: [CGRect] = []
        for cardView in cardViews {
            cardView.removeFromSuperview()
            oldFrames.append(cardView.frame)
        }
        cardViews = []
        var grid = grid
        grid.cellCount = cards.count
        var iterations = 1.0
        for (index, card) in cards.enumerated() {
            guard let cardFrame = grid[index] else {
                return
            }
            let inset = cardFrame.width * CardViewConstant.insetMultiplier
            let frame = cardFrame.insetBy(dx: inset, dy: inset)
            let cardView = CardView(frame: frame)
            
            cardView.frame = deckView.frame
            cardView.showBackSide()
            cardView.alpha = 0
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.4, delay: iterations/5.0, animations: {
                cardView.frame = frame
                cardView.alpha = 1
            }) { _ in
                UIView.transition(with: cardView, duration: 0.4, options: .transitionFlipFromRight, animations: {
                    cardView.removeBackSide()
                })
            }
            
            iterations += 1
            cardView.configure(with: card)
            addSubview(cardView)
            cardViews.append(cardView)
        }
    }
    
    func updateCardViews(with cards: [Card]) {
        let difference = cards.count - cardViews.count
        var oldFrames: [CGRect] = []
        for cardView in cardViews {
            cardView.removeFromSuperview()
            oldFrames.append(cardView.frame)
        }
        cardViews = []
        var grid = grid
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
                UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.4, delay: 0, animations: {
                    cardView.frame = frame
                })
            } else {
                cardView.frame = deckView.frame
                cardView.showBackSide()
                cardView.alpha = 0
                
                animateDealing(of: cardView, iteration: iterations, frame: frame)
                
                iterations += 1
            }
            cardView.configure(with: card)
            addSubview(cardView)
            cardViews.append(cardView)
        }
    }
    
    func replaceCardViews(at indices: [Int], cards: [Card]) {
        var iteration = 0.0
        var grid = grid
        grid.cellCount = cards.count
        
        for index in indices {
            
            let oldCardView = cardViews[index]
            zoomIn(cardView: oldCardView)
            animateReplace(of: oldCardView)
            //            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.4, delay: 0, animations: {
            //                oldCardView.frame = self.discardPile.frame
            //                oldCardView.alpha = 0
            //            }) { _ in
            //                oldCardView.removeFromSuperview()
            //            }
            iteration += 1
            let cardFrame = grid[index]!
            let inset = cardFrame.width * CardViewConstant.insetMultiplier
            let frame = cardFrame.insetBy(dx: inset, dy: inset)
            let cardView = CardView()
            cardView.frame = deckView.frame
            cardView.showBackSide()
            cardView.alpha = 0
            
            animateDealing(of: cardView, iteration: iteration, frame: frame)
            
            cardView.configure(with: cards[index])
            addSubview(cardView)
            cardViews[index] = cardView
        }
    }
    
    func removeCardViews(at indices: [Int], cards: [Card]) {
        var oldFrames: [CGRect] = []
        for cardView in cardViews {
            oldFrames.append(cardView.frame)
        }
        for index in indices {
            let cardView = cardViews[index]
            
            zoomIn(cardView: cardView)
            animateReplace(of: cardView)
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+1.4) { [weak self] in
            for cardView in self!.cardViews {
                cardView.removeFromSuperview()
            }
            self?.cardViews = []
            var grid = self!.grid
            grid.cellCount = cards.count
            for (index, card) in cards.enumerated() {
                
                let cardFrame = grid[index]!
                let inset = cardFrame.width * CardViewConstant.insetMultiplier
                let frame = cardFrame.insetBy(dx: inset, dy: inset)
                let cardView = CardView()
                cardView.frame = oldFrames[index]
                
                UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.4, delay: 0, animations: {
                    cardView.frame = frame
                    cardView.transform = .identity
                })
                
                cardView.configure(with: card)
                self?.addSubview(cardView)
                self?.cardViews.append(cardView)
            }
        }
    }
    
    private func animateRemove(of cardView: CardView, after delay: Double) {
        
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.4, delay: delay, animations: {
            cardView.frame = self.discardPile.frame
            cardView.alpha = 0
        }) { _ in
            cardView.removeFromSuperview()
        }
    }
    
    private func animateReplace(of cardView: CardView) {
        
        let viewCenter = cardView.superview!.center
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.4, delay: 0, options: .curveEaseIn, animations: {
            cardView.center = CGPoint(x: viewCenter.x, y: viewCenter.y + 250)
        }) { _ in
            self.animateRemove(of: cardView, after: 0)
        }
    }
    
    private func animateDealing(of cardView: CardView, iteration: Double, frame: CGRect) {
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.4, delay: iteration/5.0, animations: {
            cardView.frame = frame
            cardView.alpha = 1
        }) { _ in
            UIView.transition(with: cardView, duration: 0.5, options: .transitionFlipFromRight, animations: {
                cardView.removeBackSide()
            })
        }
    }
    
    func zoomIn(cardView: CardView) {
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.4, delay: 0, animations: {
            cardView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        })
    }
    
    func shakeCardViews(at indices: [Int]) {
        for index in indices {
            let cardView = cardViews[index]
            cardView.shake()
        }
    }
    
    func updateCardViewBorder(at index: Int, to color: UIColor) {
        cardViews[index].backgroundColor = .gray
    }
    
    func removeCardViewBorder(at index: Int) {
        cardViews[index].backgroundColor = .white
    }
    
    func updateCardViewBackground(at index: Int, to color: UIColor) {
        cardViews[index].backgroundColor = color
    }
    
    func getIndex(of cardView: CardView) -> Int? {
        return cardViews.firstIndex(where: { $0 == cardView })
    }
    
    func createTapGesture() -> UITapGestureRecognizer {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTap))
        return tap
    }
    
    @objc func didTap (_ sender: UITapGestureRecognizer) {
        delegate?.cardGridViewDidTapDeck(self)
    }
}

//MARK: Private methods
private extension CardGridView {
    
    func setupDeckView() {
        deckView.configureDeck()
        deckView.setBorder(borderWidth: 1.0, borderColor: .black)
        deckView.image = UIImage(named: "cardBack")
        addSubview(deckView)
        NSLayoutConstraint.activate([
            deckView.trailingAnchor.constraint(equalTo: centerXAnchor, constant: -100),
            deckView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            deckView.heightAnchor.constraint(equalToConstant: 100),
            deckView.widthAnchor.constraint(equalTo: deckView.heightAnchor, multiplier: 5/7)
        ])
        let tap = createTapGesture()
        deckView.addGestureRecognizer(tap)
        
    }
    
    func setupDiscardPile() {
        discardPile.configureDiscardPile()
        discardPile.setBorder(borderWidth: 1.0, borderColor: .black)
        addSubview(discardPile)
        NSLayoutConstraint.activate([
            discardPile.leadingAnchor.constraint(equalTo: centerXAnchor, constant: 105),
            discardPile.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            discardPile.heightAnchor.constraint(equalToConstant: 100),
            discardPile.widthAnchor.constraint(equalTo: discardPile.heightAnchor, multiplier: 5/7)
        ])
    }
}



