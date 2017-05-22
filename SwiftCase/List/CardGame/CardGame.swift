//
//  CardGame.swift
//  SwiftCase
//
//  Created by 伍腾飞 on 2017/5/21.
//  Copyright © 2017年 Shepherd. All rights reserved.
//

import UIKit

class CardGame: NSObject {
    
    // 随机16张牌
    var randomCards: [Card]
    // 得分
    var score: Int
    
    // 从一副扑克中随机抽取xx张牌，初始化游戏
    init(count: Int, from poker: Poker) {
        randomCards = []
        score = 0
        let cardsCount = poker.allCards.count
        if count <= 0 || count > cardsCount {
            return
        }
        for index in 0..<count {
            let card = poker.allCards.remove(at: Int(arc4random_uniform(UInt32(cardsCount - index))))
            randomCards.append(card)
        }
    }
    
    // 点击卡片翻牌
    func tapCard(at index: Int) {
        guard index < randomCards.count else {
            return
        }
        
        let card = randomCards[index]
        
        if !card.isFaceUp {
            // 1、不是正面朝上，就翻牌
            card.isFaceUp = true
            
            // 2、正面朝上、没有配对过、不是自己
            var other: Card?
            for (i, card) in randomCards.enumerated() {
                if card.isFaceUp && !card.isMatched && i != index {
                    other = card
                    break
                }
            }
            guard other != nil else {
                return
            }
            
            // 3、花色相同，分数+1，已配对
            if card.compare(suit: other!) {
                score += 1
                card.isMatched = true
                other!.isMatched = true
                return
            }
            
            // 4、点数相同，分数+3，已配对
            if card.compare(rank: other!) {
                score += 3
                card.isMatched = true
                other!.isMatched = true
                return
            }
            
            // 5、都不相同，将上一张牌翻到反面
            other!.isFaceUp = false
            
        }
        
    }
    
}
