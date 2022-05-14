//
//  EmojiMemoryGame.swift
//  ConcentrationGame
//
//  Created by Vitor Capretz on 14/05/22.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    @Published private var game = createMemoryGame()
    
    static func createMemoryGame() -> MemoryGame<String> {
        let emojiSet = ["👻", "🎃", "🧹", "🧙‍♀️", "🦇", "💀", "🍭", "🍬", "😈", "😱"]
        
        return MemoryGame<String>(numberOfPairsOfCards: emojiSet.count) { pairIndex in
            emojiSet[pairIndex]
        }
    }
    
    var cards: [MemoryGame<String>.Card ] {
        game.cards
    }
    
    // MARK: - Intents
    
    func choose(card: MemoryGame<String>.Card) {
        game.choose(card: card)
    }
}
