//
//  AlertViewController.swift
//  SwiftCase
//
//  Created by 伍腾飞 on 2017/4/30.
//  Copyright © 2017年 Shepherd. All rights reserved.
//

import UIKit

class AlertViewController: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addSourceCodeItem("alertc")
        
    }
    
    // MARK: UIEvents
    @IBAction func showAlert(_ sender: UIButton) {
        
        let alertC = UIAlertController(title: "My Title", message: "This is an alert", preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            self.dismiss(animated: true, completion: nil)
            print("Cancel. No change")
        }
        alertC.addAction(cancel)
        
        let confirm = UIAlertAction(title: "Confirm", style: .default) { _ in
            print("Confirm. To do something")
        }
        alertC.addAction(confirm)
        
        let delete = UIAlertAction(title: "Delete", style: .destructive) { _ in
            print("Delete. Important!")
        }
        alertC.addAction(delete)
        
        self.present(alertC, animated: true, completion: {
            // your code here
        })
        
    }
    
    @IBAction func showActionSheet(_ sender: UIButton) {
        
        let alertC = UIAlertController(title: "Options", message: "Please select one", preferredStyle: .actionSheet)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            self.dismiss(animated: true, completion: nil)
        })
        alertC.addAction(cancel)
        
        // self的生命周期 > AlertSheet，不会造成循环引用
        let cut = UIAlertAction(title: "Cut Off", style: .default) { _ in
            UIPasteboard.general.string = self.label.text
            self.label.text = ""
        }
        alertC.addAction(cut)
        
        let copy = UIAlertAction(title: "Copy", style: .default) { _ in
            UIPasteboard.general.string = self.label.text
        }
        alertC.addAction(copy)
        
        let paste = UIAlertAction(title: "Paste", style: .default) { _ in
            self.label.text = UIPasteboard.general.string
        }
        alertC.addAction(paste)
        
        self.present(alertC, animated: true, completion: nil)
        
    }
    
    @IBAction func showAlertWithForm(_ sender: UIButton) {
        
        let alertC = UIAlertController(title: "Login Login", message: "This is an alert", preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            self.dismiss(animated: true, completion: nil)
        }
        alertC.addAction(cancel)
        
        // 点击空白处收起键盘 可以用第三方切面处理
        let login = UIAlertAction(title: "Sign In", style: .default) { _ in
            
            let username = alertC.textFields![0].text
            let password = alertC.textFields![1].text
            
            self.loginAction(username, password)
        }
        alertC.addAction(login)
        
        alertC.addTextField { (textField) in
            textField.placeholder = "Your name"
        }
        
        alertC.addTextField { (textField) in
            textField.placeholder = "Your password"
            textField.isSecureTextEntry = true
            textField.keyboardType = .decimalPad
        }
        
        self.present(alertC, animated: true, completion: nil)
        
    }
    
    
    func loginAction(_ username: String?, _ password: String?) {
        
        print("username:\(username ?? "") password:\(password ?? "")")
        
    }

}
