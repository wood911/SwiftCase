//
//  DrawString.swift
//  SwiftCase
//
//  Created by 伍腾飞 on 2017/5/20.
//  Copyright © 2017年 Shepherd. All rights reserved.
//

import UIKit

class DrawString: UIView {

    var text: String!
    
    init(text: String, frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.text = text
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        
        let attribute: [NSAttributedStringKey: Any] = [.font: UIFont.systemFont(ofSize: 20), .foregroundColor: UIColor.darkText, .backgroundColor: UIColor.lightGray]
        // 自适应宽高
        let size = text.boundingRect(with: self.bounds.size, options: .usesLineFragmentOrigin, attributes: attribute, context: nil).size
        
        text.draw(in: CGRect(origin: CGPoint.zero, size: size), withAttributes: attribute)
        
    }

}


