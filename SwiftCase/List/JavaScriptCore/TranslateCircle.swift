//
//  TranslateCircle.swift
//  SwiftCase
//
//  Created by 伍腾飞 on 2017/6/18.
//  Copyright © 2017年 Shepherd. All rights reserved.
//

import UIKit

class TranslateCircle: UIView {

    var progress: Double = 0 {
        didSet {
            DispatchQueue.main.async { 
                self.setNeedsDisplay()
            }
            if progress >= 1.0 {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.milliseconds(300), execute: {
                    self.progress = 0
                })
            }
        }
    }
    private var startAngle: Double
    private var endAngle: Double
    private var radius: CGFloat
    private var circleCenter: CGPoint
    private var block: (_ btn: UIButton) -> ()
    private weak var button: UIButton!
    
    init(frame: CGRect, action: @escaping (_ btn: UIButton) -> ()) {
        block = action
        startAngle = 0
        endAngle = 0
        let width = min(frame.width, frame.height)
        radius = width * 0.5
        circleCenter = CGPoint(x: width * 0.5, y: width * 0.5)
        super.init(frame: CGRect(origin: frame.origin, size: CGSize(width: width, height: width)))
        self.backgroundColor = UIColor.hex(0x1266AB)
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
        let button = UIButton(frame: CGRect(origin: CGPoint.zero, size: self.frame.size))
        button.addTarget(self, action: #selector(buttonClick(_:)), for: .touchUpInside)
        button.setTitleColor(UIColor.white, for: [])
        button.setTitle("En", for: .normal)
        button.setTitle("Zh", for: .selected)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        self.button = button
        self.addSubview(button)
    }
    
    override func draw(_ rect: CGRect) {
        startAngle = 1.5 * Double.pi
        endAngle = 1.5 * Double.pi
        endAngle += progress * 2 * Double.pi
        let ctx = UIGraphicsGetCurrentContext()!
        ctx.setLineWidth(8)
        ctx.setStrokeColor(red: 230.0/255.0, green: 120.0/255.0, blue: 110.0/255.0, alpha: 1.0)
        ctx.addArc(center: circleCenter, radius: radius, startAngle: CGFloat(startAngle), endAngle: CGFloat(endAngle), clockwise: false)
        ctx.strokePath()
        startAngle = endAngle
    }
    
    func buttonClick(_ button: UIButton) {
        button.isSelected = !button.isSelected
        block(button)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reset() {
        progress = 0
        button.isSelected = false
    }

}
