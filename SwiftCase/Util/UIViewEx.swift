//
//  UIViewEx.swift
//  SwiftCase
//
//  Created by wtf on 2017/5/17.
//  Copyright © 2017年 Shepherd. All rights reserved.
//

import UIKit

// MARK: - extension UIView showMask
extension UIView {
    
    public typealias VoidBlock = () -> Void
    
    public func showMask(_ tapHandler: VoidBlock?) -> UIView {
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        view.isUserInteractionEnabled = true
        view.backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.7)
        
        let tap = UITapGestureRecognizer()
        view.addGestureRecognizer(tap)
        tap.handler = { sender in
            UIView.animate(withDuration: 0.5, animations: {
                if let handler = tapHandler {
                    handler()
                }
            }) { _ in
                sender.view?.removeFromSuperview()
            }
        }
        self.addSubview(view)
        
        return view
    }
    
    
    public func showMessage(_ message: String) {
        let label = UILabel()
        
        label.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.7)
        label.layer.cornerRadius = 5.0
        label.layer.masksToBounds = true
        label.text = message
        label.textAlignment = .center
        label.numberOfLines = 5
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 14)
        
        let frameW = self.frame.width
        let frameH = self.frame.height
        label.preferredMaxLayoutWidth = frameW - 60
        let size = label.text!.boundingRect(with: CGSize(width: frameW - 60, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: label.font], context: nil).size
        label.frame = CGRect(x: 30, y: (frameH - size.height - 25) * 0.5 - 20, width: frameW - 40, height: size.height + 25)
        
        self.addSubview(label)
        
        let deadlineTime = DispatchTime.now() + DispatchTimeInterval.milliseconds(1500)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
            if label.superview == self {
                label.removeFromSuperview()
            }
        }
    }
}


