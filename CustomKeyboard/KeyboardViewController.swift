//
//  KeyboardViewController.swift
//  CustomKeyboard
//
//  Created by wtf on 2017/5/17.
//  Copyright © 2017年 Shepherd. All rights reserved.
//

import UIKit

class KeyboardViewController: UIInputViewController {
    
    /**
     http://www.cocoachina.com/ios/20140918/9673.html
     */
    
    @IBOutlet var nextKeyboardButton: UIButton!
    
    let numberKeys = ["1", "2", "3", "4", "5", "6", "7", "8", "9", ".", "0", "←"]
    
    var numberBgViews: [UIView] = []
    // done 完成按钮
    lazy var doneButton: UIButton = {
        let done = UIButton(type: .custom)
        done.translatesAutoresizingMaskIntoConstraints = false
        done.setTitle("Done", for: [])
        done.addTarget(self, action: #selector(dismissKeyboard), for: .touchUpInside)
        self.view.addSubview(done)
        return done
    }()
    // 提示
    lazy var tipLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Security Keyboard"
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center
        label.sizeToFit()
        self.view.addSubview(label)
        return label
    }()
    
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        // Add custom view sizing constraints here
        stackVerticalConstraints(container: view, objects: numberBgViews)
        for view in numberBgViews {
            stackHerizontalConstraints(container: view, objects: view.subviews)
        }
        
        doneButton.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        doneButton.topAnchor.constraint(equalTo: numberBgViews.last!.topAnchor).isActive = true
        doneButton.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        doneButton.widthAnchor.constraint(equalToConstant: 66.0).isActive = true
        
        tipLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 80.0).isActive = true
        tipLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -80.0).isActive = true
        tipLabel.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        tipLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Perform custom UI setup here
        view.backgroundColor = UIColor.darkGray
        self.nextKeyboardButton = UIButton(type: .system)
        self.nextKeyboardButton.setImage(UIImage(named: "switch_language_white"), for: [])
        self.nextKeyboardButton.sizeToFit()
        self.nextKeyboardButton.translatesAutoresizingMaskIntoConstraints = false
        self.nextKeyboardButton.addTarget(self, action: #selector(handleInputModeList(from:with:)), for: .allTouchEvents)
        self.view.addSubview(self.nextKeyboardButton)
        nextKeyboardButton.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        nextKeyboardButton.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        nextKeyboardButton.widthAnchor.constraint(equalToConstant: 44.0).isActive = true
        nextKeyboardButton.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        
        // 布局思路：添加4个方块，方块中放4个数字键
        for i in 0..<5 {
            let bgView = UIView()
            view.addSubview(bgView)
            bgView.backgroundColor = UIColor.clear
            numberBgViews.append(bgView)
            if i != 4 {
                for j in 0..<3 {
                    let index = i * 3 + j
                    let button = customButton(text: numberKeys[index])
                    button.tag = index
                    bgView.addSubview(button)
                }
            } else {
                bgView.alpha = 0
            }
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated
    }
    
    override func textWillChange(_ textInput: UITextInput?) {
        // The app is about to change the document's contents. Perform any preparation here.
    }
    
    override func textDidChange(_ textInput: UITextInput?) {
        // The app has just changed the document's contents, the document context has been updated.
        
        var textColor: UIColor
        let proxy = self.textDocumentProxy
        if proxy.keyboardAppearance == UIKeyboardAppearance.dark {
            textColor = UIColor.white
        } else {
            textColor = UIColor.black
        }
        self.nextKeyboardButton.setTitleColor(textColor, for: [])
    }
    
    // 创建按钮
    func customButton(text: String) -> UIButton {
        let button = UIButton(type: .custom)
        button.setTitle(text, for: [])
        button.setTitleColor(UIColor.white, for: [])
        button.sizeToFit()
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.layer.cornerRadius = 5.0
        button.layer.masksToBounds = true
        button.backgroundColor = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1.0)
        button.addTarget(self, action: #selector(tapButton(_:)), for: .touchUpInside)
        return button
    }
    
    // 插入/删除字符
    func tapButton(_ sender: UIButton) {
        if let text = sender.currentTitle {
            if text == numberKeys.last {
                textDocumentProxy.deleteBackward()
                return
            }
            textDocumentProxy.insertText(text)
        }
    }
    
    /// stack herizontal view 布局
    ///
    /// - Parameters:
    ///   - container: 父视图
    ///   - objects: 子视图集合
    func stackHerizontalConstraints(container: UIView, objects: [UIView]) {
        guard objects.count > 0 else {
            return
        }
        // 按钮之间的间隔
        let spacing: CGFloat = 3.0
        // 按钮边缘距离父视图
        let margin = UIEdgeInsets(top: 1.5, left: 3.5, bottom: 1.5, right: 3.5)
        
        var prev: UIView?
        for view in objects {
            view.translatesAutoresizingMaskIntoConstraints = false
            view.topAnchor.constraint(equalTo: container.topAnchor, constant: margin.top).isActive = true
            view.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -margin.bottom).isActive = true
            if let prev = prev {
                prev.rightAnchor.constraint(equalTo: view.leftAnchor, constant: -spacing).isActive = true
                prev.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
            }
            prev = view
        }
        objects.first!.leftAnchor.constraint(equalTo: container.leftAnchor, constant: margin.left).isActive = true
        objects.last!.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -margin.right).isActive = true
    }
    
    /// stack vertical view 布局
    ///
    /// - Parameters:
    ///   - container: 父视图
    ///   - objects: 子视图集合
    func stackVerticalConstraints(container: UIView, objects: [UIView]) {
        guard objects.count > 0 else {
            return
        }

        var prev: UIView?
        for view in objects {
            view.translatesAutoresizingMaskIntoConstraints = false
            view.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
            view.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
            if let prev = prev {
                prev.bottomAnchor.constraint(equalTo: view.topAnchor).isActive = true
                prev.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
            }
            prev = view
        }
        objects.first!.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        objects.last!.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
    }

}
