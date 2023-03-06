//
//  ConcentrationViewController.swift
//  Set
//
//  Created by Alexander Angelov on 2.03.23.
//

import UIKit

private var cellIdentifier = "ConcentrationCell"

class ConcentrationViewController: UIViewController {
    
    //MARK: - Properties
    private lazy var game = ConcentrationModel(numberOfPairsOfCards: 8)
    private var emoji: [ConcentrationCard: String] = [:]
    private lazy var emojiChoices = theme.emojiChoices
    
    var theme: Theme = Theme.halloween {
        didSet {
            updateTheme()
            updateViewFromModel()
        }
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateTheme()
    }
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var flipsLabel: UILabel!
    
    @IBOutlet weak var pointsLabel: UILabel!
    
    @IBOutlet weak var newGameButton: UIButton!
    
    @IBOutlet weak var concentrationCollectionView: UICollectionView! {
        didSet {
            concentrationCollectionView?.dataSource = self
            concentrationCollectionView?.delegate = self
        }
    }
    
    //MARK: - IBActions
    
    @IBAction func tapNewGame(_ sender: UIButton) {
        showNewGameAlert()
    }
}

private extension ConcentrationViewController {
    
    func getEmoji(for card: ConcentrationCard) -> String {
        if emoji[card] == nil, emojiChoices.count > 0 {
            guard let randomStringIndex = emojiChoices.indices.randomElement() else {
                return "?"
            }
            emoji[card] = String(emojiChoices.remove(at: randomStringIndex))
        }
        return emoji[card] ?? "?"
    }
    
    func updateViewFromModel() {
        concentrationCollectionView.reloadData()
        updateLabel(label: pointsLabel, to: "Points: \(game.points)")
        updateLabel(label: flipsLabel, to: "Flips: \(game.flips)")
    }
    
    func updateLabel(label: UILabel, to string: String) {
        let attributes: [NSAttributedString.Key:Any] = [
            .strokeColor: theme.cardColour]
        let attrributedString = NSAttributedString(string: string, attributes: attributes)
        label.attributedText = attrributedString
    }

    func updateTheme() {
        emoji.removeAll()
        emojiChoices = theme.emojiChoices
        view.backgroundColor = theme.backgroundColour
    }
    
    func startNewGame() {
        game.newGame()
        emoji.removeAll()
        updateViewFromModel()
    }
}

//MARK: - UICollectionViewDataSource
extension ConcentrationViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return game.cards.count + 1 / 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cardCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! ConcentrationCollectionViewCell
        let card = game.cards[indexPath.item]
        if card.isFaceUp {
            cardCell.configure(text: getEmoji(for: card), backgroundColor: theme.backgroundColour)
        } else {
            cardCell.configure(text: "", backgroundColor: card.isMatched ? UIColor.clear : theme.cardColour)
        }
        return cardCell
    }

}

//MARK: - UICollectionViewDelegate
extension ConcentrationViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        game.chooseCard(at: indexPath.row)
        updateViewFromModel()
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension ConcentrationViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.size.width - 30) / 4
        let height = (collectionView.bounds.size.height - 30) / 4
        return CGSize(width: width, height: height)
    }
}

extension ConcentrationViewController {
    func showNewGameAlert() {
        let cancelAction = Alert.createAction(.cancel)
        let newGameAction = Alert.createAction(.newGame() { _ in
            self.startNewGame()
        })
        let alert = Alert.create(title: "Do you want to start a new game?", message: "Your game progress will be lost!", actions: [cancelAction, newGameAction])
        
        present(alert, animated: true)
    }
}

