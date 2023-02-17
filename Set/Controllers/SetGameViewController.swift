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
    @IBOutlet weak var hintButton: UIButton!
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        game.delegate = self
        cardGridView.delegate = self
        //deal3Button.layer.cornerRadius = 8
        //deal3Button.clipsToBounds = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        game.startNewGame()
        cardGridView.dealIntialCardsAnimated(cards: game.dealtCards)
        addTapGestures()
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        DispatchQueue.main.asyncAfter(deadline: .now()) { [weak self] in
            self?.cardGridView.updateCardViews(with: self!.game.dealtCards)
        }
    }
    
    @IBAction func tapHintButton(_ sender: UIButton) {
        game.findSetOnTheField()
    }
    
    @IBAction func tapOnNewGame(_ sender: UIButton) {
        showNewGameAlert()
    }
    
    @IBAction func tapDealButton(_ sender: UIButton) {
        game.dealThreeCards()
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
}

extension SetGameViewController: SetGameDelegate {
    
    func setGameDidFindHint(_ setGame: SetGame, at indices: [Int]) {
        for index in indices {
            cardGridView.updateCardViewBackground(at: index, to: .systemYellow)
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
        //deal3Button.isEnabled = true
    }
    
    func setGameUpdateCards(_ game: SetGame) {
        cardGridView.updateCardViews(with: game.dealtCards)
    }
    
    func setGameDidReplaceCards(_ game: SetGame) {
        cardGridView.replaceCardViews(at: game.selectedCardsIndices, with: game.dealtCards)
    }
    
    func setGame(_ setGame: SetGame, didSelectCardAt index: Int) {
        cardGridView.updateCardViewBorder(at: index, to: .green)
    }
    
    func setGameUpdatePoints(_ setGame: SetGame) {
        //pointsLabel.text = "Points: \(game.points)"
    }
    
    func setGameDidEnd(_ setGame: SetGame) {
        showGameEndAlert()
    }
    
    func setGame(_ setGame: SetGame, didCardsMatch isMatched: Bool, at indices: [Int]) {
        for index in indices {
            let color: UIColor = isMatched ? .green : .red
            cardGridView.updateCardViewBorder(at: index, to: color)
        }
    }
    
    func setGameEnableDealButton(_ setGame: SetGame, isEnabled: Bool) {
//        deal3Button.isEnabled = isEnabled
//        if !isEnabled {
//            deal3Button.backgroundColor = .white
//        } else {
//            deal3Button.backgroundColor = .systemBlue
//        }
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
