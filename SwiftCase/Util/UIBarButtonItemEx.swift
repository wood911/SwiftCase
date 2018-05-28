//
//  UIBarButtonItemEx.swift
//  SwiftCase
//
//  Created by 伍腾飞 on 2017/4/29.
//  Copyright © 2017年 Shepherd. All rights reserved.
//

import UIKit

private var block_key = "UIBarButtonItemBlockKey"

extension UIBarButtonItem {
    
    public var hander: (_ sender: Any?) -> () {
        get {
            if let target = objc_getAssociatedObject(self, &block_key) {
                return (target as! _UIBarButtonItemBlockTarget).handler
            }
            return { _ in }
        }
        set {
            let target = _UIBarButtonItemBlockTarget(handler: newValue )
            objc_setAssociatedObject(self, &block_key, target, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            self.target = target
            self.action = #selector(_UIBarButtonItemBlockTarget.invoke(_:))
        }
    }
    
}

class _UIBarButtonItemBlockTarget: NSObject {
    var handler: (_ sender: Any?) -> ()
    
    init(handler: @escaping (_ sender: Any?) -> ()) {
        self.handler = handler
        super.init()
    }
    
    @objc func invoke(_ sender: Any?) {
        handler(sender)
    }
}

