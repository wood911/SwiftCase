//
//  AirdropURLViewController.swift
//  SwiftCase
//
//  Created by wtf on 2017/4/28.
//  Copyright © 2017年 Shepherd. All rights reserved.
//

import UIKit

class AirdropURLViewController: UIViewController {

    @IBOutlet weak var myUrl: UITextField!
    @IBOutlet weak var webView: UIWebView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // ! 、 as! 慎用，在确保有效时才能使用
        webView.loadRequest(URLRequest(url: URL(string: myUrl.text ?? "http://www.swiftdeveloperblog.com")!))
        
    }
    
    
    // MARK: UI Events
    @IBAction func send(_ sender: UIButton) {
        let url = URL(string: myUrl.text!)
        guard url != nil else {
            return
        }
        let controller = UIActivityViewController(activityItems: [url!], applicationActivities: nil)
        self.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func load(_ sender: UIButton) {
        
    }
    

}
