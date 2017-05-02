//
//  SourceCodeEx.swift
//  SwiftCase
//
//  Created by 伍腾飞 on 2017/4/29.
//  Copyright © 2017年 Shepherd. All rights reserved.
//

import UIKit

extension UIViewController {
    
    public func addSourceCodeItem(_ fileName: String) {
        let item = UIBarButtonItem()
        item.title = "Code"
        item.hander = { _ in
            self.show(SourceCodeViewController(sourceCodeFileName: fileName), sender: nil)
        }
        var rightItems: [UIBarButtonItem]! = [item]
        if let items = navigationItem.rightBarButtonItems {
            rightItems = rightItems + items
        }
        navigationItem.rightBarButtonItems = rightItems
    }
    
}
