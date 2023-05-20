//
//  EmojiModel.swift
//  Set
//
//  Created by Alexander Angelov on 8.03.23.
//

import Foundation

class EmojiModel {
    
    private var emoji: [ConcentrationCard: String] = [:]
    private lazy var emojiChoices: [String] = []
    
    func getEmoji(for card: ConcentrationCard) -> String {
        if emoji[card] == nil, emojiChoices.count > 0 {
            guard let randomStringIndex = emojiChoices.indices.randomElement() else {
                return "?"
            }
            emoji[card] = String(emojiChoices.remove(at: randomStringIndex))
        }
        return emoji[card] ?? "?"
    }
    
    func removeAllEmoji() {
        emoji.removeAll()
    }
    
    func changeEmoji(to emoji: [String]) {
        emojiChoices = emoji
    }
}
