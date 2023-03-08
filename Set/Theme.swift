//
//  Theme.swift
//  ConcentrationGame
//
//  Created by Alexander Angelov on 29.09.22.
//

import Foundation
import UIKit

enum Theme : CaseIterable {
    case halloween
    case numbers
    case animals
    case weather
    case astrology
    
    var name: String {
        switch self {
            case .halloween:
                return "Halloween"
            case .numbers:
                return "Numbers"
            case .animals:
                return "Animals"
            case .weather:
                return "Weather"
            case .astrology:
                return "Astrology"
        }
    }
    
    var emojiChoices: [String] {
        switch self {
            case .halloween:
                return ["🤡", "🎃", "👻" , "🤠", "😱", "👀", "🥸", "☠️"]
            case .numbers:
                return ["1", "2", "3" , "4", "5", "6", "7", "8"]
            case .animals:
                return ["🐱", "🐶", "🐷" , "🐭", "🐼", "🐻", "🦊", "🐝"]
            case .weather:
                return ["⚡️", "🔥", "🌈", "🌪", "☀️", "🌧", "❄️", "☃️"]
            case .astrology:
                return ["💫", "🪐", "🌍", "🌙", "🌓", "🌑", "🌗", "🌕"]
        }
    }
    var backgroundColour: UIColor {
        switch self {
            case .halloween:
                return .black
            case .numbers:
                return .lightGray
            case .animals:
                return .systemGreen
            case .weather:
                return .systemPurple
            case .astrology:
                return .cyan
        }
    }
    var cardColour: UIColor {
        switch self {
            case .halloween:
                return .systemOrange
            case .numbers:
                return .white
            case .animals:
                return .darkGray
            case .weather:
                return .white
            case .astrology:
                return .blue
        }
    }
    
    static func getAllThemes() -> [Theme] {
        Theme.allCases
    }
}
