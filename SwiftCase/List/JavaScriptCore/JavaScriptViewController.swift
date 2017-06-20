//
//  JavaScriptViewController.swift
//  SwiftCase
//
//  Created by 伍腾飞 on 2017/6/17.
//  Copyright © 2017年 Shepherd. All rights reserved.
//

import UIKit
import JavaScriptCore

class JavaScriptViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    weak var translate: TranslateCircle!
    
    lazy var jsCode: String? = {
        var jsCode: String?
        if let path = Bundle.main.path(forResource: "translate", ofType: "js"), let code = try? String(contentsOfFile: path) {
            jsCode = code
        }
        return jsCode
    }()
    
    var urlStr: String = "https://www.apple.com/cn"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let translate = TranslateCircle(frame: CGRect(x: ScreenW - 70, y: ScreenH - 150, width: 50, height: 50)) { [unowned self] (btn) in
            if btn.isSelected {
                self.webView.stringByEvaluatingJavaScript(from: "TranslatePage('en')")
                let timer = DispatchSource.makeTimerSource(flags: DispatchSource.TimerFlags(rawValue: 0), queue: DispatchQueue.main)
                timer.scheduleRepeating(deadline: DispatchTime.now(), interval: DispatchTimeInterval.milliseconds(50))
                timer.setEventHandler(handler: { [unowned self] in
                    let error = self.webView.stringByEvaluatingJavaScript(from: "window.translateError")
                    if error == nil || error!.isEmpty {
                        if let progress = self.webView.stringByEvaluatingJavaScript(from: "window.translateProgress") {
                            XLog(progress)
                            XLog(Double(progress) ?? 0)
                            self.translate.progress = Double(progress) ?? 0
                            if Double(progress) ?? 0 >= 1.0 {
                                timer.cancel()
                            }
                        }
                    } else {
                        XLog("Translate Error: \(error!)")
                        timer.cancel()
                    }
                })
                timer.resume()
            } else {
                self.webView.stringByEvaluatingJavaScript(from: "RestoreOriginal()")
            }
        }
        self.view.addSubview(translate)
        translate.isHidden = true
        self.translate = translate
        
        if let url = URL(string: urlStr) {
            webView.loadRequest(URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30))
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

// MARK: - JS
extension JavaScriptViewController {
    
    /// JavaScriptCore方式交互
    func initJsContext() {
        let context = webView.value(forKeyPath: "documentView.webView.mainFrame.javaScriptContext") as! JSContext
        let bridge = AppBridge()
        context.setObject(bridge, forKeyedSubscript: "AppBridge" as NSString)
        bridge.model1.block = { obj in
            XLog(obj)
        }
    }
    
    /// Bing翻译
    func initJsCode() {
        if let code = jsCode {
            webView.stringByEvaluatingJavaScript(from: code)
            translate.reset()
        }
    }
}

// MARK: - UIWebViewDelegate
extension JavaScriptViewController: UIWebViewDelegate {
    func webViewDidFinishLoad(_ webView: UIWebView) {
        initJsCode()
        initJsContext()
        translate.isHidden = false
        if let title = webView.stringByEvaluatingJavaScript(from: "document.title") {
            self.title = title
        }
        let urlStr = webView.request?.url?.absoluteString
        XLog("URL:\(urlStr ?? "")")
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        XLog(error)
    }
}
