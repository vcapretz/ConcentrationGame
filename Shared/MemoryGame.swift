import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable {
    struct Card: Identifiable {
        var isFaceUp = false
        var isMatched = false
        let content: CardContent
        let id: Int
    }
    
    private(set) var cards: [Card]
    
    private var indexOfOneAndOnlyFaceUpCard: Int? {
        get { cards.indices.filter({ cards[$0].isFaceUp }).oneAndOnly }
        set { cards.indices.forEach { cards[$0].isFaceUp = $0 == newValue } }
    }
    
    init(numberOfPairsOfCards: Int, cardContentFactory: (Int) -> CardContent) {
        cards = []
        
        for pairIndex in 0 ..< numberOfPairsOfCards {
            let content = cardContentFactory(pairIndex)
            cards += [
                Card(content: content, id: pairIndex * 2),
                Card(content: content, id: pairIndex * 2 + 1)
            ]
        }
        
        cards = cards.shuffled()
    }
    
    mutating func choose(_ card: Card) {
        guard let chosenIndex = cards.firstIndex(where: { $0.id == card.id }) else { return }
        guard cards[chosenIndex].isFaceUp == false, cards[chosenIndex].isMatched == false else { return }
        
        if let potentialMatchIndex = indexOfOneAndOnlyFaceUpCard {
            if cards[chosenIndex].content == cards[potentialMatchIndex].content {
                cards[chosenIndex].isMatched = true
                cards[potentialMatchIndex].isMatched = true
            }
            
            cards[chosenIndex].isFaceUp = true
        } else {
            indexOfOneAndOnlyFaceUpCard = chosenIndex
        }
    }
}

extension Array {
    var oneAndOnly: Element? {
        self.count == 1 ? self.first : nil
    }
}
