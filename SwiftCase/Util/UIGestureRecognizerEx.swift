//
//  UIGestureRecognizerEx.swift
//  SwiftCase
//
//  Created by wtf on 2017/5/17.
//  Copyright © 2017年 Shepherd. All rights reserved.
//

import UIKit

// MARK: - extension UIGestureRecognizer target-handler
extension UIGestureRecognizer {
    
    static private var block_key = "UIGestureRecognizerBlockKey"
    
    public var handler: (_ sender: UIGestureRecognizer) -> Void {
        get {
            if let target = objc_getAssociatedObject(self, &UIGestureRecognizer.block_key) {
                return (target as! _UIGestureRecognizerBlockTarget).hander
            }
            return { _ in }
        }
        set {
            let target = _UIGestureRecognizerBlockTarget(hander: newValue)
            objc_setAssociatedObject(self, &UIGestureRecognizer.block_key, target, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            self.addTarget(target, action: #selector(_UIGestureRecognizerBlockTarget.invoke(_:)))
        }
    }
    
    class _UIGestureRecognizerBlockTarget: NSObject {
        
        var hander: (_ sender: UIGestureRecognizer) -> Void
        
        init(hander: @escaping (_ sender: UIGestureRecognizer) -> Void) {
            self.hander = hander
            super.init()
        }
        
        @objc func invoke(_ sender: UIGestureRecognizer) {
            hander(sender)
        }
        
    }
    
}
