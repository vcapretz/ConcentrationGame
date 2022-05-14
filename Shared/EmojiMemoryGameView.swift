import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var memoryGame: EmojiMemoryGame
    
    var body: some View {
        LazyVGrid(columns: [.init(.adaptive(minimum: 80))]) {
            ForEach(memoryGame.cards) { card in
                CardView(card: card)
                    .aspectRatio(2/3, contentMode: .fit)
                    .onTapGesture {
                        memoryGame.choose(card: card)
                    }
            }
        }
        .padding()
    }
}

struct CardView: View {
    var card: MemoryGame<String>.Card
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                if card.isFaceUp {
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(.white)
                    
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(lineWidth: edgeLineWidth)
                    
                    Text(card.content)
                } else {
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill()
                }
            }
            .foregroundColor(.orange)
            .font(.system(size: fontSize(for: geometry.size)))
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
        EmojiMemoryGameView(memoryGame: EmojiMemoryGame())
            .previewInterfaceOrientation(.portrait)
    }
}
