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
    
    var cardDictionary = [UIButton: SetGame.Card]()
    
    var dealtCards: [SetGame.Card] {
        game.dealtCards
    }
    var selectedCards: [SetGame.Card] {
        game.dealtCards.filter({$0.isSelected == true}) //?
    }
    
    var isDeckEmpty: Bool {
        game.noCardsInDeck
    }
    
//    func chooseCard(card: SetGame.Card) {
//        //game.checkIfCardsMatch(card: card)
//        updateViewFromModel()
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        game.startNewGame()
        updateViewFromModel()
        // Do any additional setup after loading the view. 90/116
    }
    
    var selectedCardsCount = 0
    
    @IBAction func tapOnCard(_ sender: UIButton) {
        
        for index in cardButtons.indices {
            if index < dealtCards.count {
                cardButtons[index].isEnabled = true
            } else {
                cardButtons[index].isEnabled = false
            }
        }
        
        if selectedCardsCount <= 2 && sender.isSelected == true {
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
            for index in dealtCards.indices {
                if cardButtons[index].isSelected == true {
                    dealtCards[index].isSelected = true
                } else {
                    dealtCards[index].isSelected = false
                }
            }
            game.checkIfCardsMatch()
            selectedCardsCount = 0
            cardButtons.forEach { card in
                card.isSelected = false
                card.isSelected = false
                card.layer.borderColor = UIColor.white.cgColor
            }
        }
        updateViewFromModel()
    }
 
    @IBAction func tapOnNewGame(_ sender: UIButton) {
        cardButtons.forEach{ cardView in
            cardView.isSelected = false
            cardView.layer.borderColor = UIColor.white.cgColor
            cardView.isEnabled = false
            cardView.setTitle("", for: UIControl.State())
        }
        game.startNewGame()
        print(dealtCards.count)
        selectedCardsCount = 0
        
        updateViewFromModel()
    }
    
    @IBAction func tapDealButton(_ sender: UIButton) {
        game.dealExtraCards(3)
        updateViewFromModel()
    }
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet var cardButtons: [UIButton]!
    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet weak var Deal3Button: UIButton!
    
    func updateViewFromModel() {
        let cardbuttonCount = cardButtons.count
        let dealtCardsCount = dealtCards.count
        for index in 0..<cardbuttonCount {
            if index < dealtCardsCount {
                for index in dealtCards.indices{
                    card = dealtCards[index]
                    let cardView = cardButtons[index]
                    cardView.setAttributedTitle(buildAttributedString(), for: UIControl.State())
                    cardButtons[index].isEnabled = true
                    if card.isSelected == true {
                        cardView.isSelected = false
                        cardView.layer.borderColor = UIColor.white.cgColor
                    }
                }
            } else {
                cardButtons[index].isEnabled = false
                cardButtons[index].setAttributedTitle(NSAttributedString(""), for: UIControl.State())
            }
        }
        pointsLabel.text = "Points: \(game.points)"
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

