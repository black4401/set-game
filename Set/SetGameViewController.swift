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
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //game.startNewGame()
        game.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        game.startNewGame()
        cardGridView.updateCardViews(with: game.dealtCards)
        
        
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
    
    @IBAction func tapOnNewGame(_ sender: UIButton) {
        showNewGameAlert()
    }
    
    @IBAction func tapDealButton(_ sender: UIButton) {
        game.dealThreeCards()
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
        cardGridView.updateCardViews(with: game.dealtCards)
    }
    
    func gameUpdateCards(_ game: SetGame) {
        cardGridView.updateCardViews(with: game.dealtCards)
    }
    
    func setGame(_ game: SetGame, didSelectCardAt index: Int) {
        cardGridView.updateCardViewBorder(at: index, to: .green)
    }
    
    func gameUpdatePoints(_ setGame: SetGame) {
        pointsLabel.text = "Points: \(game.points)"
    }
    
    func gameDidEnd(_ setGame: SetGame) {
        // end game
    }
    
    func setGame(_ setGame: SetGame, didCardsMatch isMatched: Bool, at indices: [Int]) {
        for index in indices {
            let color: UIColor = isMatched ? .green : .red
            cardGridView.updateCardViewBorder(at: index, to: color)
        }
    }
}

extension SetGameViewController {
    func showNewGameAlert() {
        let cancelAction = Alert.createAction(.cancel)
        let newGameAction = Alert.createAction(.newGame() { _ in
            self.game.startNewGame()
        })
        let alert = Alert.create(title: "Do you want to start a new game?", message: "Your game progress will be lost!", actions: [cancelAction, newGameAction])
        
        present(alert, animated: true)
    }
}

