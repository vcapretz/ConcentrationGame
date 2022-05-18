import SwiftUI

struct Cardify: AnimatableModifier {
    init(isFaceUp: Bool) {
        rotation = isFaceUp ? 0 : 180
    }
    
    var animatableData: Double {
        get { rotation }
        set { rotation = newValue }
    }
    
    var rotation: Double
    
    func body(content: Content) -> some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
            
            if rotation < 90 {
                shape
                    .fill(.white)
            } else {
                shape
                    .fill()
            }
            
            shape
                .strokeBorder(lineWidth: DrawingConstants.edgeLineWidth)
            
            content
                .opacity(rotation < 90 ? 1 : 0)
        }
        .rotation3DEffect(.degrees(rotation), axis: (0, 1, 0))
    }
    
    // MARK: - Drawing Constants
    private struct DrawingConstants {
        static let cornerRadius: CGFloat = 10.0
        static let edgeLineWidth: CGFloat = 3
        static func fontSize(for size: CGSize) -> CGFloat {
            min(size.width, size.height) * 0.70
        }
    }
}

extension View {
    func cardify(isFaceUp: Bool) -> some View {
        self.modifier(Cardify(isFaceUp: isFaceUp))
    }
}
