//
//  Poker.swift
//  SwiftCase
//
//  Created by 伍腾飞 on 2017/5/21.
//  Copyright © 2017年 Shepherd. All rights reserved.
//

import UIKit

class Poker: NSObject {
    
    // 一副扑克牌中包换52张牌，去掉大小王
    lazy var allCards: [Card] = {
        var cards: [Card] = []
        for suit in Card.allSuit() {
            for rank in Card.allRank() {
                cards.append(Card(suit: suit, rank: rank))
            }
        }
        return cards
    }()
    
}
