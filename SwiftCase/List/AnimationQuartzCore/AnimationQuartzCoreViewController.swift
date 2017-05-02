//
//  AnimationQuartzCoreViewController.swift
//  SwiftCase
//
//  Created by 伍腾飞 on 2017/4/30.
//  Copyright © 2017年 Shepherd. All rights reserved.
//

import UIKit

class AnimationQuartzCoreViewController: UIViewController {

    @IBOutlet weak var gravity: UIButton!
    @IBOutlet weak var push: UIButton!
    @IBOutlet weak var attachment: UIButton!
    
    // iOS UIKit Dynamic物理动力学特性，模拟真实世界中的一些特性，常用于游戏中
    // UIDynamicAnimator 添加或移除不同的行为来实现一些动态特性
    // 5个不同行为：
    // 吸附 UIAttachmentBehavior
    // 碰撞 UICollisionBehavior
    // 重力 UIGravityBehavior
    // 推动 UIPushBehavior
    // 捕捉 UISnapBehavior
    var animator: UIDynamicAnimator!
    var collision: UICollisionBehavior!
    // 这里为什么用可选值？参见handlerAttachment
    var attachmentBehavior: UIAttachmentBehavior?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addSourceCodeItem("animationquartzcore")
        
        animator = UIDynamicAnimator(referenceView: view)
    }
    
    
    @IBAction func gravity(_ sender: UIButton) {
        // 先移除所有行为，再添加
        animator.removeAllBehaviors()
        // 重力、推动、吸附
        let g = UIGravityBehavior(items: [gravity, push, attachment])
        animator.addBehavior(g)
        
        collision = UICollisionBehavior(items: [push, gravity, attachment])
        collision.translatesReferenceBoundsIntoBoundary = true
        animator.addBehavior(collision)
    }
    
    @IBAction func push(_ sender: UIButton) {
        animator.removeAllBehaviors()
        
        let p = UIPushBehavior(items: [gravity, push, attachment], mode: .instantaneous)
        p.magnitude = 2
        animator.addBehavior(p)
        
        collision = UICollisionBehavior(items: [push, gravity, attachment])
        collision.translatesReferenceBoundsIntoBoundary = true
        animator.addBehavior(collision)
    }
    
    @IBAction func attachment(_ sender: UIButton) {
        animator.removeAllBehaviors()
        
        let anchorPoint = CGPoint(x: attachment.center.x, y: attachment.center.y)
        attachmentBehavior = UIAttachmentBehavior(item: attachment, attachedToAnchor: anchorPoint)
        attachmentBehavior!.frequency = 0.5
        attachmentBehavior!.damping = 2
        attachmentBehavior!.length = 20
        animator.addBehavior(attachmentBehavior!)
        
        collision = UICollisionBehavior(items: [gravity, push, attachment])
        collision.translatesReferenceBoundsIntoBoundary = true
        animator.addBehavior(collision)
    }
    
    @IBAction func handlerAttachment(_ sender: UIPanGestureRecognizer) {
        if attachmentBehavior != nil {
            attachmentBehavior?.anchorPoint = sender.location(in: view)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // 视图展示时捕捉中心点
        let max = UIScreen.main.bounds
        let snap1 = UISnapBehavior(item: gravity, snapTo: CGPoint(x: max.size.width/2, y: max.size.height/2 - 50))
        let snap2 = UISnapBehavior(item: push, snapTo: CGPoint(x: max.size.width/2, y: max.size.height/2))
        let snap3 = UISnapBehavior(item: attachment, snapTo: CGPoint(x: max.size.width/2, y: max.size.height/2 + 50))
        snap1.damping = 1
        snap2.damping = 2
        snap3.damping = 4
        animator.addBehavior(snap1)
        animator.addBehavior(snap2)
        animator.addBehavior(snap3)
    }

}
