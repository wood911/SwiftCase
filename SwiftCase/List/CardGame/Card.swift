//
//  Card.swift
//  SwiftCase
//
//  Created by 伍腾飞 on 2017/5/21.
//  Copyright © 2017年 Shepherd. All rights reserved.
//

import UIKit

class Card: NSObject {
    let suit: String
    let rank: String
    var isFaceUp: Bool
    var isMatched: Bool
    
    init(suit: String, rank: String) {
        self.suit = suit
        self.rank = rank
        self.isFaceUp = false
        self.isMatched = false
    }
    
    func compare(suit card: Card) -> Bool {
        return self.suit == card.suit
    }
    
    func compare(rank card: Card) -> Bool {
        return self.rank == card.rank
    }
    
    class func allSuit() -> [String] {
        return ["❤️", "♠️", "♦️", "♣️"]
    }
    
    class func allRank() -> [String] {
        return ["A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"]
    }
    
}
