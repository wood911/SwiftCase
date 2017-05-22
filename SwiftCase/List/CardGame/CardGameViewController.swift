//
//  CardGameViewController.swift
//  SwiftCase
//
//  Created by 伍腾飞 on 2017/5/20.
//  Copyright © 2017年 Shepherd. All rights reserved.
//

import UIKit

class CardGameViewController: UIViewController {
    
    /**
     MVC编程模式推荐斯坦福大学教授iOS8公开课中的纸牌游戏，YouTube
     
     布局
     1、代码布局：当屏幕发生变化自动重新计算各个视图的frame(重新定位)
     viewDidLayoutSubviews 重写，视图从无到有、旋转都会自动调用此方法
     self.topLayoutGuide.length
     self.bottomLayoutGuide.length
     
     2、AutoResizing
     
     3、Auto Layout
     自动布局(约束)：通过一系列的约束constraint来描述视图展示位置
     
     注意：1 & 2 可以混用，但要关闭3(AutoLayout)
     translatesAutoresizingMaskIntoConstraints 自动布局时要关闭AutoResizing
     
     4、Size Classes
     全屏幕布局，把所有Apple设备不同尺寸的屏幕抽象为9种不同的大小 >iOS7
     regular：表示界面正常
     compact：表示界面内容比较紧凑
     any：表示任意，全设备通用，默认
     竖屏：wChR -> iPhone(4,5,6,7,6P,7P,SE)
     横屏：wChC -> iPhone(4,5,6,7,SE)
          wRhC -> iPhone Plus(6P,7P)
     
     本Demo演示Size Classes在Storyboard中的布局
     stackView已经支持Size Classes，用AutoLayout比较简单
     
     */

    @IBOutlet var allCards: [UIButton]!
    @IBOutlet var score: [UILabel]!
    @IBOutlet var message: [UILabel]!
    
    let cardCount = 12
    var poker: Poker!
    var game: CardGame!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        poker = Poker()
        game = CardGame(count: cardCount, from: poker)
        
    }
    
    override func viewDidLayoutSubviews() {
        updateUI()
    }
    
    func updateUI() {
        for (index, card) in game.randomCards.enumerated() {
            // 竖屏
            let wChR = allCards[index]
            // 横屏
            let wChC = allCards[index + cardCount]
            // plus横屏
            let wRhC = allCards[index + 2 * cardCount]
            
            var title = card.suit + card.rank
            var image = UIImage(named: "cardfront.png")
            if !card.isFaceUp {
                title = ""
                image = UIImage(named: "cardback.png")
            }
            
            wChR.setTitle(title, for: [])
            wChR.setBackgroundImage(image, for: [])
            wChC.setTitle(title, for: [])
            wChC.setBackgroundImage(image, for: [])
            wRhC.setTitle(title, for: [])
            wRhC.setBackgroundImage(image, for: [])
            
            for score in score {
                score.text = "Score: \(game.score)"
            }
        }
    }

    // 重置游戏
    @IBAction func reset(_ sender: UIButton) {
        if poker.allCards.count < cardCount {
            poker = Poker()
        }
        game = CardGame(count: cardCount, from: poker)
        updateUI()
    }
    
    // 点击纸牌按钮，翻牌，匹配纸牌，计算分数，更新UI
    @IBAction func tapCard(_ sender: UIButton) {
        let index = allCards.index(of: sender)
        if let index = index {
            game.tapCard(at: index % cardCount)
        }
        updateUI()
        
    }
    
    
}
