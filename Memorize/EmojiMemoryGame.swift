//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by atom on 2022/5/21.
//

import SwiftUI

//ViewModel
//ObservableObject 使得 @Published 修饰的变量改变时，会发送UI刷新公告
class EmojiMemoryGame: ObservableObject{
    // 难度枚举
    enum Difficulty: String, CaseIterable, Identifiable {
        case easy, medium, hard
        var id: String { self.rawValue }
        
        // 根据难度返回卡片对数
        var numberOfPairs: Int {
            switch self {
            case .easy: return 3
            case .medium: return 6
            case .hard: return 10
            }
        }
    }
    
    // 静态emoji数组
    static var emojis = ["😀","🦴","🍎","🍇","🏀","🎽","🤣","🐶","🐱","🐭",
                         "🐹","🐰","🦊","🐵","🐢","🍎","🍋","🍉","🥩","🍳"]
    
    // 当前难度设置
    @Published var difficulty: Difficulty = .medium {
        didSet {
            resetGame()
        }
    }
    
    // 根据指定难度创建游戏
    static func createMemoryGame(with difficulty: Difficulty) -> MemoryGame<String> {
        let numberOfPairs = difficulty.numberOfPairs
        return MemoryGame<String>(numberOfPairsOfCards: numberOfPairs, createCardContent: {
            index in
            return EmojiMemoryGame.emojis[index]
        } )
    }
    
    // @Published使得model每次改变时，都会发送UI刷新公告
    @Published private var model: MemoryGame<String> = createMemoryGame(with: .medium)
    
    // 获取卡片数组
    var cards: Array<MemoryGame<String>.Card>{
        return model.cards
    }
    
    // MARK: - Intent(s)
    // 向Model发送从View接收到的指令
    func choose(_ card: MemoryGame<String>.Card){
        model.choose(card)
    }
    
    // 重置游戏
    func resetGame() {
        model = EmojiMemoryGame.createMemoryGame(with: difficulty)
    }
    
    // 设置难度并重置游戏
    func setDifficulty(_ newDifficulty: Difficulty) {
        if difficulty != newDifficulty {
            difficulty = newDifficulty
            resetGame()
        }
    }
}
