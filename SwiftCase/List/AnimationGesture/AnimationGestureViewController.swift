//
//  AnimationGestureViewController.swift
//  SwiftCase
//
//  Created by 伍腾飞 on 2017/4/30.
//  Copyright © 2017年 Shepherd. All rights reserved.
//

import UIKit

class AnimationGestureViewController: UIViewController {

    @IBOutlet weak var penguinView: UIImageView!
    
    var frames: NSArray?
    var dieCenter: CGPoint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addSourceCodeItem("animationgesture")
        
        let frames = [UIImage(named: "penguin_walk01")!,
                      UIImage(named: "penguin_walk02")!,
                      UIImage(named: "penguin_walk03")!,
                      UIImage(named: "penguin_walk04")!]
        
        penguinView.animationDuration = 0.15
        penguinView.animationRepeatCount = 2
        penguinView.animationImages = frames
        
        // swipe right to walk right
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(walkRight(_:)))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
        
        // swipe left to walk left
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(walkLeft(_:)))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
        
        // tap view to jump
        let tap = UITapGestureRecognizer(target: self, action: #selector(jump(_:)))
        view.addGestureRecognizer(tap)
        
        // long press will be die
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPress(_:)))
        view.addGestureRecognizer(longPress)
    }
    
    // walk right 中心点到达又边界，返回至左边继续运动
    @objc func walkRight(_ sender: UIGestureRecognizer) {
        if penguinView.center.x > view.frame.size.width {
            penguinView.center = CGPoint(x: 0, y: penguinView.center.y)
        }
        penguinView.transform = CGAffineTransform.identity
        // start walk animation
        penguinView.startAnimating()
        // 0.6s move 30
        UIView.animate(withDuration: 0.6) {
            let center = self.penguinView.center;
            self.penguinView.center = CGPoint(x: center.x + 30, y: center.y)
        }
    }
    
    @objc func walkLeft(_ sender: UIGestureRecognizer) {
        if penguinView.center.x < 0 {
            penguinView.center = CGPoint(x: view.frame.size.width - penguinView.frame.size.width, y: penguinView.center.y)
        }
        // flip around for walking left
        penguinView.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        penguinView.startAnimating()
        
        UIView.animate(withDuration: 0.6) { 
            let center = self.penguinView.center
            self.penguinView.center = CGPoint(x: center.x - 30, y: center.y)
        }
    }
    
    @objc func jump(_ sender: UIGestureRecognizer) {
        penguinView.startAnimating()
        // 0.25s jump up 50 and 0.25 jump down 50
        UIView.animate(withDuration: 0.25, animations: { 
            let center = self.penguinView.center;
            self.penguinView.center = CGPoint(x: center.x, y: center.y - 50)
        }) { _ in
            let center = self.penguinView.center
            self.penguinView.center = CGPoint(x: center.x, y: center.y + 50)
        }
        
    }
    
    // 消失于屏幕下方，然后又回到原位置
    @objc func longPress(_ sender: UIGestureRecognizer) {
        UIView.animate(withDuration: 0.33, animations: { 
            self.dieCenter = self.penguinView.center
            self.penguinView.center = CGPoint(x: self.penguinView.center.x, y: self.view.frame.size.height)
        }) { _ in
            UIView.animate(withDuration: 0.25, animations: { 
                self.penguinView.center = self.dieCenter!
            })
        }
    }

}
