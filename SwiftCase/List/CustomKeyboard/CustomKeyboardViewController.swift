//
//  CustomKeyboardViewController.swift
//  SwiftCase
//
//  Created by wtf on 2017/5/18.
//  Copyright © 2017年 Shepherd. All rights reserved.
//

import UIKit

class CustomKeyboardViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var fieldBottom: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 注册键盘通知
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
        
        
    }
    
    // 键盘升起
    func keyboardWillShow(_ notification: Notification) {
        // 获取键盘动画
        let option = notification.userInfo![UIKeyboardAnimationCurveUserInfoKey] as! UIViewAnimationOptions
        // 动画时长
        let duration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        // 键盘高度
        let frame = notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! CGRect
        // 添加修改约束动画
        self.fieldBottom.constant = frame.height
        UIView.animate(withDuration: duration, delay: 0, options: option, animations: { 
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    // 键盘收起
    func keyboardWillHide(_ notification: Notification) {
        self.fieldBottom.constant = 20
        let option = notification.userInfo![UIKeyboardAnimationCurveUserInfoKey] as! UIViewAnimationOptions
        let duration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        UIView.animate(withDuration: duration, delay: 0, options: option, animations: { 
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    // 点击空白收起键盘
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.textField.resignFirstResponder()
    }

}
