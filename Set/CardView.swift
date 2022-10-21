//
//  CardView.swift
//  Set
//
//  Created by Alexander Angelov on 17.10.22.
//

import UIKit

class CardView: UIButton {

    var card: Card = Card()
    
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
        switch card.elementCount {
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
        var result = ""
        for _ in 1...count {
            result.append(shape)
            result.append("\n")
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
