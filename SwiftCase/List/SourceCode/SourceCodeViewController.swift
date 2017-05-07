//
//  SourceCodeViewController.swift
//  SwiftCase
//
//  Created by wtf on 2017/4/28.
//  Copyright © 2017年 Shepherd. All rights reserved.
//

import UIKit
import WebKit

class SourceCodeViewController: UIViewController {
    
    var name: String?
    
    // 懒加载 
    // 循环引用问题 Swift提供了：弱引用（weak reference）和无主引用（unowned reference）
    // week:生命周期中可能变为nil，即可选类型变量前  
    // unowned:生命周期中值不会改变，适用于非可选类型
    // 闭包Closure循环引用优雅解决方案 [unowned self] in
    lazy var webView: WKWebView = {
        [unowned self] in
        print("DEBUG:\(self.view)")
        // 编译错误：Instance member 'view' cannot be used on type 'SourceCodeViewController'
        // Why? 闭包中访问成员变量、方法不可省略self，编译器时刻提醒你这里很可能造成内存泄漏
//        print(view)
        let webView = WKWebView()
        return webView
    }()
    
    init(sourceCodeFileName: String) {
        super.init(nibName: nil, bundle: nil)
        name = sourceCodeFileName;
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Source Code"
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)
        // 布局，先添加到父视图中，再添加约束，iOS 8 之后不用添加约束直接isActive=true激活就好
        let topC = NSLayoutConstraint(item: webView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0)
        let bottomC = NSLayoutConstraint(item: webView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        let leftC = NSLayoutConstraint(item: webView, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 0)
        let rightC = NSLayoutConstraint(item: webView, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: 0)
        view.addConstraints([topC, bottomC, leftC, rightC])
        
        if let sourceName = name, let path = Bundle.main.path(forResource: sourceName, ofType: "html") {
            let url = URL(fileURLWithPath: path)
            webView.loadFileURL(url, allowingReadAccessTo: url)
        }
        
    }

}
