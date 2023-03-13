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
    private lazy var grid: Grid = {
        let grid = Grid(layout: .aspectRatio(CardViewConstant.aspectRatio), frame: gridFrame)
        return grid
    } ()
    
    private var gridFrame: CGRect {
        let height = bounds.height - deckView.bounds.height - 20
        return CGRect(x: 0, y: 0, width: bounds.width, height: height)
    }
    
    weak var delegate: CardGridViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupDeckView()
        setupDiscardPile()
    }
    
    func resizeGrid() {
        grid.frame = gridFrame
    }
    
    func dealIntialCards(cards: [Card]) {
        var oldFrames: [CGRect] = []
        for cardView in cardViews {
            cardView.removeFromSuperview()
            oldFrames.append(cardView.frame)
        }
        cardViews = []
        
        grid.cellCount = cards.count
        
        for (index, card) in cards.enumerated() {
            guard let cardFrame = grid[index] else {
                return
            }
            let frame = self.getCardFrame(from: cardFrame)
            let cardView = CardView(frame: frame)
            
            cardView.frame = deckView.frame
            cardView.showBackSide(isDiscarded: false)
            cardView.alpha = 0
            let delay = Double(index)/AnimationConstants.initialDealingDelayModifier
            
            animateDealing(of: cardView, delay: delay, frame: frame)
            
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
        grid.cellCount = cards.count
        var iterations = 1.0
        
        for (index, card) in cards.enumerated() {
            guard let cardFrame = grid[index] else {
                return
            }
            
            let frame = self.getCardFrame(from: cardFrame)
            let cardView = CardView(frame: frame)
            
            if index < cardIndexOffset {
                cardView.frame = oldFrames[index]
                UIViewPropertyAnimator.runningPropertyAnimator(withDuration: AnimationConstants.standardDuration, delay: 0, options: .curveEaseInOut, animations: {
                    cardView.frame = frame
                })
            } else {
                cardView.frame = deckView.frame
                cardView.showBackSide(isDiscarded: false)
                cardView.alpha = 0
                let delay = iterations/AnimationConstants.standardDelayModifier
                
                animateDealing(of: cardView, delay: delay, frame: frame)
                
                iterations += 1
            }
            cardView.configure(with: card)
            addSubview(cardView)
            cardViews.append(cardView)
        }
    }
    
    func replaceCardViews(at indices: [Int], cards: [Card]) {
        var iteration = 0.0
        grid.cellCount = cards.count
        
        for index in indices {
            
            let oldCardView = cardViews[index]
            let removalDelay = iteration/AnimationConstants.removalDelayModifier
            zoomIn(cardView: oldCardView)
            animateMatchMovement(of: oldCardView, delay: removalDelay)
            
            iteration += 1
            let cardFrame = grid[index]!
            
            let frame = self.getCardFrame(from: cardFrame)
            let cardView = CardView(frame: frame)
            
            cardView.frame = deckView.frame
            cardView.showBackSide(isDiscarded: false)
            cardView.alpha = 0
            let dealingDelay = iteration/AnimationConstants.standardDelayModifier
            
            animateDealing(of: cardView, delay: dealingDelay, frame: frame)
            
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
            let delay = iteration/AnimationConstants.removalDelayModifier
            
            zoomIn(cardView: cardView)
            animateMatchMovement(of: cardView, delay: delay)
            iteration += 1
        }
        relayoutCardViews(at: indices, cards: cards, oldFrames: oldFrames)
    }
    
    func relayoutCardViews(at indices: [Int], cards: [Card], oldFrames: [CGRect]) {
        
        let delay = AnimationConstants.standardDuration*3
        
        DispatchQueue.main.asyncAfter(deadline: .now()+delay) { [weak self] in
            
            guard let self = self else {
                return
            }
            
            for cardView in self.cardViews {
                cardView.removeFromSuperview()
            }
            
            self.cardViews.removeAll()
            var grid = self.grid
            grid.cellCount = cards.count
            
            var indexIncrement = 0
            for (index, card) in cards.enumerated() {
                
                let cardFrame = grid[index]!
                
                let frame = self.getCardFrame(from: cardFrame)
                let cardView = CardView(frame: frame)
                
                if indices.contains(where: { $0 == index}) {
                    indexIncrement += 1
                }
                cardView.frame = oldFrames[index + indexIncrement]
                
                UIViewPropertyAnimator.runningPropertyAnimator(withDuration: AnimationConstants.standardDuration, delay: 0, animations: {
                    cardView.frame = frame
                    cardView.transform = .identity
                })
                
                cardView.configure(with: card)
                self.addSubview(cardView)
                self.cardViews.append(cardView)
            }
        }
    }
    
    func zoomIn(cardView: CardView) {
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: AnimationConstants.standardDuration, delay: 0, animations: {
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
    
    func resetDeck() {
        deckView.setUpCardBack()
    }
    
    func resetDiscardPile() {
        discardPile.removeCardBack()
    }
    
    func removeDeckViewImage() {
        deckView.removeCardBack()
    }
    
//    func addCardBackToDiscardPile() {
//        discardPile.isEmpty = false
//    }
    
    @objc func didTap (_ sender: UITapGestureRecognizer) {
        delegate?.cardGridViewDidTapDeck(self)
    }
}

//MARK: Private methods
private extension CardGridView {
    
    func animateMovementToDiscard(of cardView: CardView, after delay: Double) {
        cardView.layer.zPosition = 10
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: AnimationConstants.standardDuration, delay: delay, animations: {
            cardView.frame = self.discardPile.frame
            self.animateShowBackSide(of: cardView, delay: delay, frame: self.discardPile.frame)
        })
    }
    
    func animateMatchMovement(of cardView: CardView, delay: Double) {
        cardView.layer.zPosition = 10
        let viewCenter = cardView.superview!.center
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: AnimationConstants.standardDuration, delay: delay, options: .curveEaseInOut, animations: {
            cardView.center = CGPoint(x: viewCenter.x, y: viewCenter.y)
        }) { [weak self] _ in
            self?.animateMovementToDiscard(of: cardView, after: delay)
        }
    }
    
    func animateDealing(of cardView: CardView, delay: Double, frame: CGRect) {
        cardView.backgroundColor = .clear
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: AnimationConstants.standardDuration, delay: delay, animations: {
            cardView.frame = frame
            cardView.alpha = 1
        }) { _ in
            UIView.transition(with: cardView, duration: AnimationConstants.standardDuration, options: .transitionFlipFromRight, animations: {
                cardView.removeBackSide()
            })
            cardView.backgroundColor = .white
        }
    }
    
    func animateShowBackSide(of cardView: CardView, delay: Double, frame: CGRect) {
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: AnimationConstants.standardDuration, delay: delay, animations: {
            cardView.frame = frame
            cardView.alpha = 1
        }) { _ in
            UIView.transition(with: cardView, duration: AnimationConstants.standardDuration, options: .transitionFlipFromLeft, animations: {
                cardView.showBackSide(isDiscarded: true)
            })
        }
    }
    
    func createTapGesture() -> UITapGestureRecognizer {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTap))
        return tap
    }
    
    func setupDeckView() {
        
        deckView.configure()
        deckView.setBorder(borderWidth: 1.0, borderColor: .white)
        deckView.image = UIImage(named: "cardBack")
        addSubview(deckView)
        
        NSLayoutConstraint.activate([
            deckView.trailingAnchor.constraint(equalTo: centerXAnchor, constant: -100),
            deckView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            deckView.heightAnchor.constraint(equalToConstant: 100),
            deckView.widthAnchor.constraint(equalTo: deckView.heightAnchor, multiplier: CardViewConstant.aspectRatio)
        ])
        
        let tap = createTapGesture()
        deckView.addGestureRecognizer(tap)
    }
    
    func setupDiscardPile() {
        //discardPile.isEmpty = true
        discardPile.configure()
        discardPile.setBorder(borderWidth: 1.0, borderColor: .white)
        addSubview(discardPile)
        NSLayoutConstraint.activate([
            discardPile.leadingAnchor.constraint(equalTo: centerXAnchor, constant: 105),
            discardPile.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            discardPile.heightAnchor.constraint(equalToConstant: 100),
            discardPile.widthAnchor.constraint(equalTo: discardPile.heightAnchor, multiplier: CardViewConstant.aspectRatio)
        ])
    }
    
    func getCardFrame(from cardFrame: CGRect) -> CGRect {
        let inset = cardFrame.width * CardViewConstant.insetMultiplier
        return cardFrame.insetBy(dx: inset, dy: inset)
    }
}

enum AnimationConstants {
    static let initialDealingDelayModifier: Double = 7.0
    static let removalDelayModifier: Double = 7.0
    static let standardDelayModifier: Double = 5.0
    
    static let standardDuration: Double = 0.4
}
