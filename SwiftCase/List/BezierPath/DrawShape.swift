//
//  DrawShape.swift
//  SwiftCase
//
//  Created by 伍腾飞 on 2017/5/20.
//  Copyright © 2017年 Shepherd. All rights reserved.
//

import UIKit

class DrawShape: UIView {

    override func draw(_ rect: CGRect) {
        
        // 1、绘制矩形
        var frame = CGRect(x: 5, y: 5, width: self.frame.width * 0.5, height: self.frame.height * 0.5)
        var path = UIBezierPath(rect: frame)
        UIColor.black.setStroke()
        UIColor.orange.setFill()
        path.lineWidth = 5
        path.stroke()
        path.fill()
        
        // 2、绘制正方形
        let width = self.bounds.width * 0.4
        frame = CGRect(x: self.frame.width * 0.5 + 15.0, y: 0, width: width, height: width)
        path = UIBezierPath(roundedRect: frame, cornerRadius: width * 0.2)
        UIColor.blue.setStroke()
        UIColor.gray.setFill()
        path.lineWidth = 5
        path.stroke()
        path.fill()
        
        // 3、绘制圆形
        frame = CGRect(x: self.frame.width * 0.5 + 25.0, y: self.frame.height * 0.35, width: self.frame.width * 0.2, height: self.frame.width * 0.2)
        path = UIBezierPath(roundedRect: frame, cornerRadius: frame.width * 0.5)
        UIColor.purple.setFill()
        path.fill()
        
        // 4、三角形
        path = UIBezierPath()
        path.lineWidth = 12
        path.lineJoinStyle = .bevel
        path.lineCapStyle = .square
        
        path.move(to: CGPoint(x: 10, y: self.frame.height * 0.5 + 15))
        path.addLine(to: CGPoint(x: 120, y: self.frame.height * 0.5 + 15))
        path.addLine(to: CGPoint(x: 10, y: self.frame.height * 0.5 + 75))
        path.close()
        
        UIColor.blue.setStroke()
        path.stroke()
        
    }

}
