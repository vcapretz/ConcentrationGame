import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var game: EmojiMemoryGame
    @State private var dealt = Set<Int>()
    @Namespace private var dealingNamespace
    
    private func deal(_ card: EmojiMemoryGame.Card) {
        dealt.insert(card.id)
    }
    
    private func isDealt(_ card: EmojiMemoryGame.Card) -> Bool {
        dealt.contains(card.id)
    }
    
    private func dealAnimation(for card: EmojiMemoryGame.Card) -> Animation {
        var delay = 0.0
        
        if let index = game.cards.firstIndex(where: { $0.id == card.id }) {
            delay = Double(index) * (CardConstants.totalDealDuration / Double(game.cards.count))
        }
        
        return .easeInOut(duration: CardConstants.dealDuration).delay(delay)
    }
    
    private func zIndex(of card: EmojiMemoryGame.Card) -> Double {
        -Double(game.cards.firstIndex(where: { $0.id == card.id }) ?? 0)
    }
    
    var gameBody: some View {
        AspectVGrid(items: game.cards, aspectRatio: 2 / 3) { card in
            if !isDealt(card) {
                Color.clear
            } else {
                CardView(card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .padding(4)
                    .transition(.asymmetric(insertion: .identity, removal: .scale).animation(.easeInOut))
                    .zIndex(zIndex(of: card))
                    .onTapGesture {
                        withAnimation(.easeInOut) {
                            game.choose(card)
                        }
                    }
            }
        }
        .padding(.horizontal)
        .foregroundColor(CardConstants.color)
    }
    
    var deckBody: some View {
        ZStack {
            ForEach(game.cards.filter { isDealt($0) == false }) { card in
                CardView(card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .zIndex(zIndex(of: card))
                    .transition(.asymmetric(insertion: .opacity, removal: .identity).animation(.easeInOut))
            }
        }
        .frame(width: CardConstants.undealtWidth, height: CardConstants.undealtHeight)
        .foregroundColor(CardConstants.color)
        .onTapGesture {
            for card in game.cards {
                withAnimation(dealAnimation(for: card)) {
                    deal(card)
                }
            }
        }
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            deckBody
                .padding(.bottom, 30)
            
            VStack {
                gameBody
                
                Button("Restart") {
                    withAnimation {
                        dealt = []
                        game.restart()
                    }
                }
            }
        }
    }
    
    private struct CardConstants {
        static let color = Color.orange
        static let aspectRatio: CGFloat = 2 / 3
        static let dealDuration: Double = 0.5
        static let totalDealDuration: Double = 2
        static let undealtHeight: CGFloat = 90
        static let undealtWidth = undealtHeight * aspectRatio
    }
}

struct CardView: View {
    let card: EmojiMemoryGame.Card
    
    @State private var animatedBonusRemaining: Double = 0.0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Group {
                    if card.isConsumingBonusTime {
                        Pie(
                            startAngle: .degrees(0 - 90),
                            endAngle: .degrees((1 - animatedBonusRemaining) * 360 - 90)
                        )
                        .onAppear {
                            animatedBonusRemaining = card.bonusRemaining
                            
                            withAnimation(.linear(duration: card.bonusTimeRemaining)) {
                                animatedBonusRemaining = 0
                            }
                        }
                    } else {
                        Pie(
                            startAngle: .degrees(0 - 90),
                            endAngle: .degrees((1 - card.bonusRemaining) * 360 - 90)
                        )
                    }
                }
                    .padding(5)
                    .opacity(0.5)
                
                Text(card.content)
                    .rotationEffect(.degrees(card.isMatched ? 360 : 0))
                    .animation(.easeInOut(duration: 1), value: card.isMatched)
                    .font(.system(size: DrawingConstants.fontSize(for: geometry.size)))
            }
            .cardify(isFaceUp: card.isFaceUp)
            .opacity(card.isMatched && !card.isFaceUp ? 0 : 1)
        }
    }
    
    
    // MARK: - Drawing Constants
    private struct DrawingConstants {
        static func fontSize(for size: CGSize) -> CGFloat {
            min(size.width, size.height) * 0.70
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        game.choose(game.cards.first!)
        return EmojiMemoryGameView(game: game)
    }
}
