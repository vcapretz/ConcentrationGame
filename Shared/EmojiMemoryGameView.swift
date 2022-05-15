import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var game: EmojiMemoryGame
    
    var body: some View {
        LazyVGrid(columns: [.init(.adaptive(minimum: 80))]) {
            ForEach(game.cards) { card in
                CardView(card: card)
                    .aspectRatio(2/3, contentMode: .fit)
                    .onTapGesture {
                        game.choose(card)
                    }
            }
        }
        .padding(.horizontal)
    }
}

struct CardView: View {
    let card: EmojiMemoryGame.Card
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                if card.isFaceUp {
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(.white)
                    
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .strokeBorder(lineWidth: edgeLineWidth)
                    
                    Text(card.content)
                } else {
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill()
                }
            }
            .foregroundColor(.orange)
            .font(.system(size: fontSize(for: geometry.size)))
            .opacity(card.isMatched && !card.isFaceUp ? 0 : 1)
        }
    }
    
    
    // MARK: - Drawing Constants
    let cornerRadius: CGFloat = 10.0
    let edgeLineWidth: CGFloat = 3
    func fontSize(for size: CGSize) -> CGFloat {
        min(size.width, size.height) * 0.75
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiMemoryGameView(game: EmojiMemoryGame())
    }
}
