//
//  ConcentrationGameApp.swift
//  Shared
//
//  Created by Vitor Capretz on 14/05/22.
//

import SwiftUI

@main
struct ConcentrationGameApp: App {
    let memoryGame = EmojiMemoryGame()
    
    var body: some Scene {
        WindowGroup {
            EmojiMemoryGameView(memoryGame: memoryGame)
        }
    }
}
