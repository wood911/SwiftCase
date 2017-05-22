//
//  ProgressView.swift
//  SwiftCase
//
//  Created by 伍腾飞 on 2017/5/20.
//  Copyright © 2017年 Shepherd. All rights reserved.
//

import UIKit

class ProgressView: UIView {
    
    // timer需要强引用保存起来，不然autorelease释放掉了
    var timer: Timer!
    // 进度
    var progress: CGFloat
    // 线条颜色
    var color: UIColor
    
    override init(frame: CGRect) {
        
        progress = 0
        color = UIColor.red
        
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { [unowned self] (timer) in
            self.progress += 0.02
            self.color = UIColor(red: 1 - self.progress, green: self.progress, blue: 0, alpha: 1.0)
            self.setNeedsDisplay()
            if self.progress >= 1.0 {
                timer.invalidate()
            }
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        let center = CGPoint(x: self.frame.width * 0.5, y: self.frame.height * 0.5)
        let startAngle = CGFloat(Double.pi * 3 / 2)
        let endAngle = startAngle + progress * CGFloat(Double.pi * 2)
        print("\(startAngle) \(endAngle)")
        let path = UIBezierPath(arcCenter: center, radius: self.frame.width * 0.45, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        color.setStroke()
        path.lineWidth = 10
        path.stroke()
        
    }

}
