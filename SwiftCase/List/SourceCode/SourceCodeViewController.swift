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
    
    var webView: WKWebView {
        return WKWebView()
    }
    
//    init(sourceCodeFileName: String?) {
//        super.init()
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)
        NSLayoutConstraint(item: webView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: webView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: webView, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: webView, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: 0).isActive = true
        
        guard (name != nil) else { return }
        let url = URL(fileURLWithPath: Bundle.main.path(forResource: name!, ofType: "html")!)
        if #available(iOS 9.0, *) {
            webView.loadFileURL(url, allowingReadAccessTo: url)
        } else {
            let tmpUrl = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("www")
            try! FileManager.default.createDirectory(at: tmpUrl, withIntermediateDirectories: true, attributes: nil)
            let dstUrl = tmpUrl.appendingPathComponent(name!)
            try? FileManager.default.removeItem(at: dstUrl)
            try! FileManager.default.copyItem(at: url, to: dstUrl)
            webView.load(URLRequest(url: dstUrl))
        }
        
    }

}
