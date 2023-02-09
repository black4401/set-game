//
//  ViewController.swift
//  Set
//
//  Created by Alexander Angelov on 15.10.22.
//

import UIKit

class SetGameViewController: UIViewController {
    
    private lazy var game = SetGame()
    
    @IBOutlet private weak var cardGridView: CardGridView!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet weak var deal3Button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        game.startNewGame()
        game.delegate = self
        //updateViewFromModel()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        game.startNewGame()
        cardGridView.updateCardViews(with: game.cardsOnField)
        
        cardGridView.addGestureRecognizer(createTapGesture())
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        DispatchQueue.main.asyncAfter(deadline: .now()) { [weak self] in
            self?.cardGridView.updateCardViews(with: self!.game.dealtCards)
        }
    }
    
    func createTapGesture() -> UITapGestureRecognizer {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTap))
        return tap
    }
    
    @objc func didTap(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: cardGridView)
        guard let cardView = cardGridView.hitTest(location, with: nil) as? CardView,
              let index = cardGridView.getIndex(of: cardView) else {
            return
        }
        if !game.selectedCardsIndices.contains(index) {
            cardGridView.updateCardViewBorder(at: index, to: .green)
            game.selectCard(at: index)
        } else {
            cardGridView.removeCardViewBorder(at: index)
            game.deselectCard(at: index)
        }
    }
    
//    @IBAction func tapOnCard(_ sender: UIButton) {
//
//        if selectedCardsCount <= 2 && sender.isSelected {
//            selectedCardsCount -= 1
//            sender.isSelected = false
//            sender.layer.borderColor = UIColor.white.cgColor
//        } else if selectedCardsCount < 3 {
//            selectedCardsCount += 1
//            sender.isSelected = true
//            sender.layer.borderWidth = 3.0
//            sender.layer.borderColor = UIColor.green.cgColor
//        }
//
//        if selectedCardsCount == 3 {
//            for index in game.dealtCards.indices {
//                if cardButtons[index].isSelected {
//                    game.dealtCards[index].isSelected = true
//                } else {
//                    game.dealtCards[index].isSelected = false
//                }
//            }
//            game.checkIfCardsMatch()
//            selectedCardsCount = 0
//            cardButtons.forEach { card in
//                card.isSelected = false
//                card.layer.borderColor = UIColor.white.cgColor
//            }
//        }
//        updateViewFromModel()
//    }
    
    @IBAction func tapOnNewGame(_ sender: UIButton) {
//        cardButtons.forEach { cardView in
//            cardView.isSelected = false
//            cardView.layer.borderColor = UIColor.white.cgColor
//            cardView.isEnabled = false
//            cardView.setTitle("", for: UIControl.State())
//        }
//        game.startNewGame()
//        selectedCardsCount = 0
//        updateViewFromModel()
    }
    
    @IBAction func tapDealButton(_ sender: UIButton) {
        game.dealThreeCards()
        print("Attempting to deal 3 cards")
        //game.dealExtraCards(3)
        //updateViewFromModel()
    }
    
    
    func updateViewFromModel() {
//        let cardbuttonCount = cardButtons.count
//        let dealtCardsCount = game.dealtCards.count
//        for index in 0..<cardbuttonCount {
//            if index < dealtCardsCount {
//                for index in game.dealtCards.indices {
//                    currentCard = game.dealtCards[index]
//                    let cardView = cardButtons[index]
//                    cardView.setAttributedTitle(buildAttributedString(), for: UIControl.State())
//                    cardButtons[index].isEnabled = true
//                }
//            } else {
//                cardButtons[index].isEnabled = false
//                cardButtons[index].setAttributedTitle(NSAttributedString(""), for: UIControl.State())
//            }
//        }
//        pointsLabel.text = "Points: \(game.points)"
    }
 
}

extension SetGameViewController: SetGameDelegate {
 
    func updateCardsOnField(_ game: SetGame) {
        cardGridView.updateCardViews(with: game.cardsOnField)
    }
    
    func setGameUpdateCards(_ game: SetGame) {
        cardGridView.updateCardViews(with: game.cardsOnField)
    }
    
    func setGame(_ game: SetGame, didSelectCardAt index: Int) {
        cardGridView.updateCardViewBorder(at: index, to: .green)
    }
}

