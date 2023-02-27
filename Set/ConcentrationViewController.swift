//
//  ViewController.swift
//  ConcentrationGame
//
//  Created by Alexander Angelov on 19.09.22.
//

import UIKit

class ConcentrationViewController: UIViewController {
    
    private lazy var game = ConcentrationModel(numberOfPairsOfCards: numberOfPairsOFCards)
    
    private var theme: Theme = Theme.getRandomTheme()
    private lazy var currentEmoji = theme.emojiChoices
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = theme.backgroundColour
        for index in cardButtons.indices {
            cardButtons[index].backgroundColor = theme.cardColour
        }
    }
    
    private var numberOfPairsOFCards: Int {
        return (cardButtons.count + 1) / 2
    }
    
    @IBOutlet weak var pointsCountLabel: UILabel!
    
    @IBAction func newGameButton(_ sender: UIButton) {
        startNewGame()
    }
    
    @IBOutlet private weak var flipCountLabel: UILabel!
    
    @IBOutlet private var cardButtons: [UIButton]!
    
    @IBAction private func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.firstIndex(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModal()
        } else{
            print("not in range")
        }
    }
    
    private func updateViewFromModal(){
        
        flipCountLabel.text = "Flips: \(game.flips)"
        pointsCountLabel.text = "Points: \(game.points)"
        
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp{
                button.setTitle(emoji(for: card), for: UIControl.State.normal)
                button.backgroundColor = UIColor.white
                button.isEnabled = false
            } else{
                button.setTitle("", for: UIControl.State.normal)
                button.backgroundColor = card.isMatched ? UIColor.clear : theme.cardColour
                if card.isMatched {
                    button.isEnabled = false
                } else {
                    button.isEnabled = true
                }
            }
        }
    }
    
    private var emoji = [ConcentrationCard:String]()
    
    private func emoji(for card: ConcentrationCard) -> String {
        if emoji[card] == nil,
           currentEmoji.count > 0 {
            
            emoji[card] = currentEmoji.remove(at: currentEmoji.count.arc4random)
        }
        return emoji[card] ?? "?"
    }
    private func startNewGame(){
        game.newGame()
        updateViewFromModal()
    }
    
}
extension Int {
    var arc4random: Int {
        if self == 0 {
            return 0
        } else if self < 0{
            return -Int(arc4random_uniform(UInt32(self)))
        }
        return Int(arc4random_uniform(UInt32(self)))
    }
}

