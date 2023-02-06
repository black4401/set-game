//
//  ViewController.swift
//  Set
//
//  Created by Alexander Angelov on 15.10.22.
//

import UIKit

class SetGameViewController: UIViewController {
    
    private var game = SetGame()
    var currentCard = Card(id: 1, numberOfShapes: .two, shape: .square, color: .red, shading: .filled)
    private var selectedCardsCount = 0
    
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet var cardButtons: [UIButton]!
    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet weak var deal3Button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        game.startNewGame()
        updateViewFromModel()
    }
    
    @IBAction func tapOnCard(_ sender: UIButton) {
        
        if selectedCardsCount <= 2 && sender.isSelected {
            selectedCardsCount -= 1
            sender.isSelected = false
            sender.layer.borderColor = UIColor.white.cgColor
        } else if selectedCardsCount < 3 {
            selectedCardsCount += 1
            sender.isSelected = true
            sender.layer.borderWidth = 3.0
            sender.layer.borderColor = UIColor.green.cgColor
        }
        
        if selectedCardsCount == 3 {
            for index in game.dealtCards.indices {
                if cardButtons[index].isSelected {
                    game.dealtCards[index].isSelected = true
                } else {
                    game.dealtCards[index].isSelected = false
                }
            }
            game.checkIfCardsMatch()
            selectedCardsCount = 0
            cardButtons.forEach { card in
                card.isSelected = false
                card.layer.borderColor = UIColor.white.cgColor
            }
        }
        updateViewFromModel()
    }
    
    @IBAction func tapOnNewGame(_ sender: UIButton) {
        cardButtons.forEach { cardView in
            cardView.isSelected = false
            cardView.layer.borderColor = UIColor.white.cgColor
            cardView.isEnabled = false
            cardView.setTitle("", for: UIControl.State())
        }
        game.startNewGame()
        selectedCardsCount = 0
        updateViewFromModel()
    }
    
    @IBAction func tapDealButton(_ sender: UIButton) {
        game.dealExtraCards(3)
        updateViewFromModel()
    }
    
    
    func updateViewFromModel() {
        let cardbuttonCount = cardButtons.count
        let dealtCardsCount = game.dealtCards.count
        for index in 0..<cardbuttonCount {
            if index < dealtCardsCount {
                for index in game.dealtCards.indices {
                    currentCard = game.dealtCards[index]
                    let cardView = cardButtons[index]
                    cardView.setAttributedTitle(buildAttributedString(), for: UIControl.State())
                    cardButtons[index].isEnabled = true
                }
            } else {
                cardButtons[index].isEnabled = false
                cardButtons[index].setAttributedTitle(NSAttributedString(""), for: UIControl.State())
            }
        }
        pointsLabel.text = "Points: \(game.points)"
    }
    
    func getColor() -> UIColor {
        switch currentCard.color {
            case .red:
                return UIColor.red
            case .blue:
                return UIColor.blue
            case .purple:
                return UIColor.purple
        }
    }
    func getShape() -> String {
        switch currentCard.shape {
            case .triangle:
                return "▲"
            case .oval:
                return "●"
            case .square:
                return "■"
        }
    }
    func getCount() -> Int {
        switch currentCard.numberOfShapes {
            case .one:
                return 1
            case .two:
                return 2
            case .three:
                return 3
        }
    }
    func buildAttributedString() -> NSAttributedString {
        let string = buildString(count: getCount(), shape: getShape())
        let attributes = colorShadeAttributes(color: getColor())
        
        return NSAttributedString(string: string, attributes: attributes)
    }
    
    func buildString(count: Int, shape: String) -> String {
        var result = "\n"
        for _ in 1...count {
            result.append(shape)
            result.append("\n")
        }
        return result
    }
    func colorShadeAttributes(color: UIColor) -> [NSAttributedString.Key : Any] {
        switch currentCard.shading {
            case .filled:
                return [
                    .strokeWidth : -1.0,
                    .foregroundColor : color.withAlphaComponent(1),
                    .font: UIFont.boldSystemFont(ofSize: 15)]
            case .empty:
                return [
                    .strokeWidth : 10.0,
                    .foregroundColor : color.withAlphaComponent(1),
                    .font: UIFont.boldSystemFont(ofSize: 15)]
            case .striped:
                return [
                    .strokeWidth : -1.0,
                    .foregroundColor : color.withAlphaComponent(0.15),
                    .font: UIFont.boldSystemFont(ofSize: 15)]
        }
    }
}

