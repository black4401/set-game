//
//  ViewController.swift
//  Set
//
//  Created by Alexander Angelov on 15.10.22.
//

import UIKit

class SetGameViewController: UIViewController {
    
    private var game = PlayingSet()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dealStartingCards()
        //cardButtons[1].setAttributedTitle(NSAttributedString(string: "ASGGASG"), for: UIControl.State.normal)
        // Do any additional setup after loading the view. 90/116
    }
    
    var cardButtonsSelected: [Int] = []
    var matchingCardsIndexes: [Int] = []
    
    @IBAction func tapOnCard(_ sender: CardView) {
        if cardButtonsSelected.count < 3 {
            if !sender.card.isSelected {
                sender.isSelected = true
                sender.layer.borderWidth = 3.0
                sender.layer.borderColor = UIColor.green.cgColor
                
                var indexes = game.chooseCard(card: sender.card)
                
                if indexes != nil {
                    matchingCardsIndexes = indexes!
                    matchingCardsIndexes.forEach { index in
                        vizualizeCard(index: index)
                    }
                } else {
                    cardButtonsSelected.append(sender.card.indexOnField)
                }
            } else {
                sender.isSelected = false
                sender.layer.borderColor = UIColor.white.cgColor
                cardButtonsSelected.remove(at: cardButtonsSelected.firstIndex(of: sender.card.indexOnField)!)
            }
        }
        
    }
    
    @IBOutlet var cardButtons: [CardView]!
    
    private func updateViewFromModal() {
        //implement
        game.cardsOnTheField.forEach{ card in
            if card.isSelected {
                cardButtons[card.indexOnField].isSelected = false
            }
        }
    }
    
    private func vizualizeCard(index: Int) {
        var cardView = CardView()
        cardView.card = game.dealCard()
        //var card = game.dealCard()
        //var thing = CardView.buildAttributedString()
        cardButtons[index].setAttributedTitle(cardView.buildAttributedString(), for: UIControl.State.normal)
    }
    func dealStartingCards() {
        for index in 0...11 {
            vizualizeCard(index: index)
        }
    }
    
    
}

