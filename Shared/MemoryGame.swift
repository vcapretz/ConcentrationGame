//
//  MemoryGame.swift
//  ConcentrationGame
//
//  Created by Vitor Capretz on 14/05/22.
//

import Foundation

struct MemoryGame<CardContent> {
    struct Card: Identifiable {
        var isFaceUp = false
        var isMatched = false
        var content: CardContent
        var id: Int
    }
    
    var cards: [Card]
    
    init(numberOfPairsOfCards: Int, cardContentFactory: (Int) -> CardContent) {
        cards = [Card]()
        
        for pairIndex in 0 ..< numberOfPairsOfCards {
            let content = cardContentFactory(pairIndex)
            cards += [Card(content: content, id: pairIndex * 2), Card(content: content, id: pairIndex * 2 + 1)]
        }
        
        cards = cards.shuffled()
    }
    
    mutating func choose(card: Card) {
        guard let chosenIndex = cards.firstIndex(where: { gameCard in
            gameCard.id == card.id
        }) else { return }
        
        cards[chosenIndex].isFaceUp.toggle()
    }
}
