import SwiftUI

class EmojiMemoryGame: ObservableObject {
    typealias Card = MemoryGame<String>.Card
    
    @Published private var game = createMemoryGame()
    
    private static let emojiSet = ["๐ป", "๐", "๐งน", "๐งโโ๏ธ", "๐ฆ", "๐", "๐ญ", "๐ฌ", "๐", "๐ฑ"]
    
    private static func createMemoryGame() -> MemoryGame<String> {
        MemoryGame<String>(numberOfPairsOfCards: emojiSet.count) { pairIndex in
            emojiSet[pairIndex]
        }
    }
    
    var cards: [Card] {
        game.cards
    }
    
    // MARK: - Intents
    
    func choose(_ card: Card) {
        game.choose(card)
    }
    
    func restart() {
        game = EmojiMemoryGame.createMemoryGame()
    }
}
