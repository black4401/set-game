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
    
    func dealIntialCards(cards: [Card]) {
        var oldFrames: [CGRect] = []
        for cardView in cardViews {
            cardView.removeFromSuperview()
            oldFrames.append(cardView.frame)
        }
        cardViews = []
        var grid = grid
        grid.cellCount = cards.count
        
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
            animateDealing(of: cardView, delay: Double(index)/7.0, frame: frame)
            
            cardView.configure(with: card)
            addSubview(cardView)
            cardViews.append(cardView)
        }
    }
    
    func updateCardViews(with cards: [Card]) {
        let difference = cards.count - cardViews.count
        let cardIndexOffset = cards.count - difference
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
            
            if index < cardIndexOffset {
                cardView.frame = oldFrames[index]
                UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.4, delay: 0, options: .curveEaseInOut, animations: {
                    cardView.frame = frame
                })
            } else {
                cardView.frame = deckView.frame
                cardView.showBackSide()
                cardView.alpha = 0
                
                animateDealing(of: cardView, delay: iterations/5.0, frame: frame)
                
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
            animateMatchMovement(of: oldCardView, delay: iteration/10.0)
            
            iteration += 1
            let cardFrame = grid[index]!
            let inset = cardFrame.width * CardViewConstant.insetMultiplier
            let frame = cardFrame.insetBy(dx: inset, dy: inset)
            let cardView = CardView()
            cardView.frame = deckView.frame
            cardView.showBackSide()
            cardView.alpha = 0
            
            animateDealing(of: cardView, delay: iteration/5.0, frame: frame)
            
            cardView.configure(with: cards[index])
            addSubview(cardView)
            cardViews[index] = cardView
        }
    }
    
    func removeCardViews(at indices: [Int], cards: [Card]) {
        var oldFrames: [CGRect] = []
        var iteration = 0.0
        for cardView in cardViews {
            oldFrames.append(cardView.frame)
        }
        for index in indices {
            let cardView = cardViews[index]
            
            zoomIn(cardView: cardView)
            animateMatchMovement(of: cardView, delay: iteration/10.0)
            iteration += 1
        }
        relayoutCardViews(at: indices, cards: cards, oldFrames: oldFrames)
    }
    
    func relayoutCardViews(at indices: [Int], cards: [Card], oldFrames: [CGRect]) {
        DispatchQueue.main.asyncAfter(deadline: .now()+1.2) { [weak self] in
            
            guard let cardViews = self?.cardViews else {
                return
            }
            
            for cardView in cardViews {
                cardView.removeFromSuperview()
            }
            self?.cardViews.removeAll()
            guard var grid = self?.grid else {
                return
            }
            
            grid.cellCount = cards.count
            var indexIncrement = 0
            for (index, card) in cards.enumerated() {
                
                let cardFrame = grid[index]!
                let inset = cardFrame.width * CardViewConstant.insetMultiplier
                let frame = cardFrame.insetBy(dx: inset, dy: inset)
                let cardView = CardView()
                if indices.contains(where: { $0 == index}) {
                    indexIncrement += 1
                }
                cardView.frame = oldFrames[index + indexIncrement]
                
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
        cardViews[index].backgroundColor = .lightGray
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
    
    func resetDeckAndDiscardPileState() {
        deckView.isEmpty = false
        deckView.image = UIImage(named: "cardBack")
        discardPile.isEmpty = true
        discardPile.image = nil
    }
    
    func removeDeckViewImage() {
        deckView.image = nil
    }
    
    func addCardBackToDiscardPile() {
        discardPile.image = deckView.image
    }
    
    @objc func didTap (_ sender: UITapGestureRecognizer) {
        delegate?.cardGridViewDidTapDeck(self)
    }
}

//MARK: Private methods
private extension CardGridView {
    
    func animateMovementToDiscard(of cardView: CardView, after delay: Double) {
        cardView.layer.zPosition = 10
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.4, delay: delay, animations: {
            cardView.frame = self.discardPile.frame
            cardView.alpha = 0
        }) { _ in
            cardView.removeFromSuperview()
        }
    }
    
    func animateMatchMovement(of cardView: CardView, delay: Double) {
        cardView.layer.zPosition = 10
        let viewCenter = cardView.superview!.center
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.4, delay: delay, options: .curveEaseInOut, animations: {
            cardView.center = CGPoint(x: viewCenter.x, y: viewCenter.y)
        }) { [weak self] _ in
            self?.animateMovementToDiscard(of: cardView, after: delay)
        }
    }
    
    func animateDealing(of cardView: CardView, delay: Double, frame: CGRect) {
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.4, delay: delay, animations: {
            cardView.frame = frame
            cardView.alpha = 1
        }) { _ in
            UIView.transition(with: cardView, duration: 0.4, options: .transitionFlipFromRight, animations: {
                cardView.removeBackSide()
            })
        }
    }
    
    func createTapGesture() -> UITapGestureRecognizer {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTap))
        return tap
    }
    
    func setupDeckView() {
        deckView.isEmpty = false
        deckView.configure()
        deckView.setBorder(borderWidth: 1.0, borderColor: .white)
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
        discardPile.isEmpty = true
        discardPile.configure()
        discardPile.setBorder(borderWidth: 1.0, borderColor: .white)
        addSubview(discardPile)
        NSLayoutConstraint.activate([
            discardPile.leadingAnchor.constraint(equalTo: centerXAnchor, constant: 105),
            discardPile.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            discardPile.heightAnchor.constraint(equalToConstant: 100),
            discardPile.widthAnchor.constraint(equalTo: discardPile.heightAnchor, multiplier: 5/7)
        ])
    }
}
