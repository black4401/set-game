//
//  ConcentrationViewController.swift
//  Set
//
//  Created by Alexander Angelov on 2.03.23.
//

import UIKit

private var cellIdentifier = "ConcentrationCellIdentifier"

class ConcentrationViewController: UIViewController {
    
    //MARK: - Properties
    private lazy var game = ConcentrationModel(numberOfPairsOfCards: ConcentrationConstants.numberOfPairsOfCards)
    private lazy var emojiModel = EmojiModel()
    
    var theme: Theme = Theme.halloween {
        didSet {
            updateTheme()
            updateViewFromModel()
        }
    }
    
    //MARK: - Lifecycle
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
        emojiModel.removeAllEmoji()
        emojiModel.changeEmoji(to: theme.emojiChoices)
        view.backgroundColor = theme.backgroundColour
    }
    
    func startNewGame() {
        game.newGame()
        emojiModel.removeAllEmoji()
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
        cardCell.layer.cornerRadius = ConcentrationConstants.cornerRadius
        if card.isFaceUp {
            cardCell.configure(text: emojiModel.getEmoji(for: card), backgroundColor: theme.backgroundColour)
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
        let totalSpacing = (ConcentrationConstants.itemsInRow + 1)*ConcentrationConstants.spacingBetweenCells
        
        let width = (concentrationCollectionView.bounds.width - totalSpacing)/ConcentrationConstants.itemsInRow
        return CGSize(width: width, height: width)
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

struct ConcentrationConstants {
    static let numberOfPairsOfCards = 8
    
    static let spacingBetweenCells = 16.0
    static let itemsInRow = 4.0
    static let cornerRadius: CGFloat = 5
}

