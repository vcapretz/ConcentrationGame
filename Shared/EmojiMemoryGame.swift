import SwiftUI

class EmojiMemoryGame: ObservableObject {
    @Published private var game = createMemoryGame()
    
    private static let emojiSet = ["👻", "🎃", "🧹", "🧙‍♀️", "🦇", "💀", "🍭", "🍬", "😈", "😱"]
    
    private static func createMemoryGame() -> MemoryGame<String> {
        MemoryGame<String>(numberOfPairsOfCards: emojiSet.count) { pairIndex in
            emojiSet[pairIndex]
        }
    }
    
    var cards: [MemoryGame<String>.Card] {
        game.cards
    }
    
    // MARK: - Intents
    
    func choose(_ card: MemoryGame<String>.Card) {
        game.choose(card)
    }
}
