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
    @IBOutlet weak var hintButton: UIButton!
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        game.delegate = self
        cardGridView.delegate = self
        
        newGameButton.tintColor = .customBaseColor
        hintButton.tintColor = .customBaseColor
        tabBarController?.tabBar.tintColor = .customBaseColor
        tabBarController?.tabBar.backgroundColor = .customBaseSecondaryColor
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        game.startNewGame()
        cardGridView.dealIntialCards(cards: game.dealtCards)
        addTapGestures()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: { [weak self] _ in
            self!.cardGridView.resizeGrid()
            self!.cardGridView.updateCardViews(with: self!.game.dealtCards)
        })
    }
    
    @IBAction func tapHintButton(_ sender: UIButton) {
        game.findSetOnTheField()
    }
    
    @IBAction func tapOnNewGame(_ sender: UIButton) {
        showNewGameAlert()
        hintButton.tintAdjustmentMode = .normal
        newGameButton.tintAdjustmentMode = .normal
    }
    
    @objc func didTap(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: cardGridView)
        guard let cardView = cardGridView.hitTest(location, with: nil) as? CardView,
              let index = cardGridView.getIndex(of: cardView) else {
            return
        }
        if !game.isSelected(at: index) {
            cardGridView.updateCardViewBorder(at: index, to: .green)
            game.selectCard(at: index)
        } else {
            cardGridView.removeCardViewBorder(at: index)
            game.deselectCard(at: index)
        }
    }
}

extension SetGameViewController: SetGameDelegate {
    
    func setGameDidFindHint(_ setGame: SetGame, at indices: [Int]) {
        for index in indices {
            cardGridView.updateCardViewBackground(at: index, to: .setGameHintColor)
        }
        cardGridView.isUserInteractionEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            for index in indices {
                self?.cardGridView.updateCardViewBackground(at: index, to: .white)
            }
            self?.cardGridView.isUserInteractionEnabled = true
        }
    }
    
    func setGamePrepareNewGame(_ setGame: SetGame) {
        cardGridView.resetDeck()
        cardGridView.resetDiscardPile()
        cardGridView.dealIntialCards(cards: game.dealtCards)
    }
    
    func setGameUpdateCards(_ game: SetGame) {
        cardGridView.updateCardViews(with: game.dealtCards)
    }
    
    func setGameDidReplaceCards(_ game: SetGame) {
        cardGridView.replaceCardViews(at: game.selectedCardsIndices, cards: game.dealtCards)
    }
    
    func setGameDidRemoveCards(_ game: SetGame) {
        cardGridView.removeCardViews(at: game.selectedCardsIndices, cards: game.dealtCards)
    }
    
    func setGame(_ setGame: SetGame, didSelectCardAt index: Int) {
        cardGridView.updateCardViewBorder(at: index, to: .green)
    }
    
    func setGameUpdatePoints(_ setGame: SetGame) {
        pointsLabel.text = "Points: \(game.points)"
    }
    
    func setGameDidEnd(_ setGame: SetGame) {
        showGameEndAlert()
    }
    
    func setGame(_ setGame: SetGame, didFindMissmatchAt indices: [Int]) {
        cardGridView.shakeCardViews(at: indices)
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) { [weak self] in
            for index in indices {
                self?.cardGridView.removeCardViewBorder(at: index)
            }
        }
    }
    
    func setGameEnableDealButton(_ setGame: SetGame, isEnabled: Bool) {
        if !isEnabled {
            cardGridView.removeDeckViewImage()
        }
    }
    
    func setGameDidShuffleCardsOnField(_ setGame: SetGame, indices: [Int]) {
        cardGridView.updateCardViews(with: game.dealtCards)
    }
}

extension SetGameViewController {
    
    func addTapGestures() {
        cardGridView.addGestureRecognizer(createTapGesture())
        cardGridView.addGestureRecognizer(createSwipeDownGesture())
        cardGridView.addGestureRecognizer(createRotationGesture())
    }
    
    func createTapGesture() -> UITapGestureRecognizer {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTap))
        return gesture
    }
    
    func createSwipeDownGesture() -> UISwipeGestureRecognizer {
        let gesture = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeDown))
        gesture.direction = .down
        return gesture
    }
    
    func createRotationGesture() -> UIRotationGestureRecognizer {
        let gesture = UIRotationGestureRecognizer(target: self, action: #selector(didRotateWithGesture))
        return gesture
    }
    
    @objc func didSwipeDown(_ sender: UISwipeGestureRecognizer) {
        game.dealThreeCards()
    }
    
    @objc func didRotateWithGesture(_ sender: UIRotationGestureRecognizer) {
        if sender.state == .began {
            game.shuffleCardsOnField()
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
    
    func showGameEndAlert() {
        let newGameAction = Alert.createAction(.newGame() { _ in
            self.game.startNewGame()
        })
        let alert = Alert.create(title: "Game ended", message: "Your Score is: \(game.points)", actions: [newGameAction])
        
        present(alert, animated: true)
    }
}

extension SetGameViewController: CardGridViewDelegate {
    
    func cardGridViewDidTapDeck(_ cardGridView: CardGridView) {
        game.dealThreeCards()
    }
}
