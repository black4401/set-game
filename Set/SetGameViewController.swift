//
//  ViewController.swift
//  Set
//
//  Created by Alexander Angelov on 15.10.22.
//

import UIKit

class SetGameViewController: UIViewController {
    
    private var game = SetGame()
    var card = SetGame.Card(id: 1, numberOfShapes: .two, shape: .square, color: .red, shading: .filled)
    
    var dealtCards: [SetGame.Card] {
        game.dealtCards
    }
    
    var isDeckEmpty: Bool {
        game.noCardsInDeck
    }
    
    func chooseCard(card: SetGame.Card) {
        game.chooseCard(card: card)
        updateViewFromModel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        game.startNewGame()
        updateViewFromModel()
        // Do any additional setup after loading the view. 90/116
    }
    
    var selectedCardsCount = 0
    
    @IBAction func tapOnCard(_ sender: UIButton) {
        
        if selectedCardsCount <= 2 && sender.isSelected == true {
            selectedCardsCount -= 1
            sender.isSelected = false
            sender.layer.borderColor = UIColor.white.cgColor
        } else if selectedCardsCount < 3 {
            selectedCardsCount += 1
            sender.isSelected = true
            sender.layer.borderWidth = 3.0
            sender.layer.borderColor = UIColor.green.cgColor
        } else {
            print("3 cards are already selected - can`t deselect")
        }
        
        if selectedCardsCount == 3 {
            dealtCards.forEach { card in
                chooseCard(card: card)
            }
        }
        updateViewFromModel()
    }
    
    @IBAction func tapOnNewGame(_ sender: UIButton) {
        game.startNewGame()
        updateViewFromModel()
    }
    
    @IBAction func tapDealButton(_ sender: UIButton) {
        game.dealExtraCards(3)
        updateViewFromModel()
    }
    @IBOutlet var cardButtons: [UIButton]!
    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet weak var Deal3Button: UIButton!
    
    func updateViewFromModel() {
        if dealtCards.count != 0 {
            for index in dealtCards.indices{
                card = dealtCards[index]
                let cardView = cardButtons[index]
                cardView.setAttributedTitle(buildAttributedString(), for: UIControl.State.normal)
            }
            if dealtCards.count >= 24{
                print("No more room on the field")
            } else {
                for index in dealtCards.count...23 {
                    cardButtons[index].setTitle(" ", for: UIControl.State())
                }
            }
        }
    }
    
    func getColor() -> UIColor {
        switch card.color {
            case .red:
                return UIColor.red
            case .blue:
                return UIColor.blue
            case .purple:
                return UIColor.purple
        }
    }
    func getShape() -> String {
        switch card.shape {
            case .triangle:
                return "▲"
            case .oval:
                return "●"
            case .square:
                return "■"
        }
    }
    func getCount() -> Int {
        switch card.numberOfShapes {
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
            if count == 1 {
                result.append("\n")
            }
        }
        return result
    }
    func colorShadeAttributes(color: UIColor) -> [NSAttributedString.Key : Any] {
        switch card.shading {
            case .filled:
                return [
                    .strokeWidth : -1.0,
                    .foregroundColor : color.withAlphaComponent(1),
                    .font: UIFont.boldSystemFont(ofSize: 30)]
            case .empty:
                return [
                    .strokeWidth : 10.0,
                    .foregroundColor : color.withAlphaComponent(1),
                    .font: UIFont.boldSystemFont(ofSize: 30)]
            case .striped:
                return [
                    .strokeWidth : -1.0,
                    .foregroundColor : color.withAlphaComponent(0.15),
                    .font: UIFont.boldSystemFont(ofSize: 30)]
        }
    }
}

