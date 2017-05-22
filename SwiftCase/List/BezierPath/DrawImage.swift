//
//  DrawImage.swift
//  SwiftCase
//
//  Created by 伍腾飞 on 2017/5/20.
//  Copyright © 2017年 Shepherd. All rights reserved.
//

import UIKit

class DrawImage: UIView {
    
    var image: UIImage!
    
    init(image: UIImage, frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.image = image
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 此方法用于CoreGraphics绘图，只调用一次
    // 核心绘图的功能都集成到UIKit里面了
    override func draw(_ rect: CGRect) {
        
        // 1、创建临时画布，大小为ImageView的尺寸
        UIGraphicsBeginImageContext(self.bounds.size)
        
        // 2、在上下文中绘制图像，绘制空心圆形
        let width = min(self.bounds.width, self.bounds.height) * 0.8
        let imageRect = CGRect(x: (self.frame.width - width) * 0.5, y: (self.frame.height - width) * 0.5, width: width, height: width)
        let path = UIBezierPath(ovalIn: imageRect)
        // 线的颜色
        UIColor(red: 0.3, green: 0.7, blue: 0.75, alpha: 1.0).setStroke()
        path.lineWidth = 3.0
        path.stroke()
        // 剪切掉封闭区域之外的内容，相当于圆角
        path.addClip()
        
        // 3、在View中放一张图片，用圆的边缘扣取这张图
        image.draw(in: self.bounds)
        // 从刚创建的临时画布中生成图形对象
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        let imageView = UIImageView(frame: self.bounds)
        imageView.image = newImage
        self.addSubview(imageView)
        // 关闭绘图上下文对象
        UIGraphicsEndImageContext()
        
    }

}
