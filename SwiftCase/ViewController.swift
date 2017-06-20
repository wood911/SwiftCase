//
//  ViewController.swift
//  SwiftCase
//
//  Created by wtf on 2017/4/28.
//  Copyright © 2017年 Shepherd. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var list: [String] {
        let path: String = Bundle.main.path(forResource: "ProjectList", ofType: "plist")!
        let array = NSArray.init(contentsOfFile: path)
        guard (array != nil) else {
            return []
        }
        return array as! [String]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: "cell")
        }
        cell?.textLabel?.text = list[indexPath.row]
        return cell!;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let title = list[indexPath.row]
        // swift中switch更强大，匹配的模式更多（区间匹配、元组deng） 不用写break，fallthrough表示continue
        switch indexPath.row {
        case 0:
            let playground = SourceCodeViewController(sourceCodeFileName: "basicplayground")
            playground.title = title
            self.show(playground, sender: nil)
        case 1:
            let playground = SourceCodeViewController(sourceCodeFileName: "closureplayground")
            playground.title = title
            self.show(playground, sender: nil)
        case 2:
            let playground = SourceCodeViewController(sourceCodeFileName: "enumplayground")
            playground.title = title
            self.show(playground, sender: nil)
        case 3:
            let playground = SourceCodeViewController(sourceCodeFileName: "functionplayground")
            playground.title = title
            self.show(playground, sender: nil)
        case 4:
            let playground = SourceCodeViewController(sourceCodeFileName: "genericplayground")
            playground.title = title
            self.show(playground, sender: nil)
        case 5:
            let playground = SourceCodeViewController(sourceCodeFileName: "optionalplayground")
            playground.title = title
            self.show(playground, sender: nil)
        case 6:
            let playground = SourceCodeViewController(sourceCodeFileName: "structplayground")
            playground.title = title
            self.show(playground, sender: nil)
        case 7:
            let playground = SourceCodeViewController(sourceCodeFileName: "subscriptplayground")
            playground.title = title
            self.show(playground, sender: nil)
        case 8:
            let airdrop = UIStoryboard(name: "Airdrop", bundle: nil).instantiateInitialViewController()!
            airdrop.title = title
            self.show(airdrop, sender: nil)
        case 9:
            let QRcode = UIStoryboard(name: "AVFoundationQRcode", bundle: nil).instantiateInitialViewController()!
            QRcode.title = title
            self.show(QRcode, sender: nil)
        case 10:
            let alertrC = UIStoryboard(name: "AlertC", bundle: nil).instantiateInitialViewController()!
            alertrC.title = title
            self.show(alertrC, sender: nil)
        case 11:
            let animationQuartzCore = UIStoryboard(name: "AnimationQuartzCore", bundle: nil).instantiateInitialViewController()!
            animationQuartzCore.title = title
            self.show(animationQuartzCore, sender: nil)
        case 12:
            let animationGesture = UIStoryboard(name: "AnimationGesture", bundle: nil).instantiateInitialViewController()!
            animationGesture.title = title
            self.show(animationGesture, sender: nil)
        case 13:
            let contact = UIStoryboard(name: "BasicAgenda", bundle: nil).instantiateInitialViewController()!
            contact.title = title
            self.show(contact, sender: nil)
        case 14:
            let calendar = UIStoryboard(name: "Calendar", bundle: nil).instantiateInitialViewController()!
            calendar.title = title
            self.show(calendar, sender: nil)
        case 15:
            let ibeacon = UIStoryboard(name: "iBeacon", bundle: nil).instantiateInitialViewController()!
            ibeacon.title = title
            self.show(ibeacon, sender: nil)
        case 16:
            let ibeacon = UIStoryboard(name: "ChatPeer2Peer", bundle: nil).instantiateInitialViewController()!
            ibeacon.title = title
            self.show(ibeacon, sender: nil)
        case 17:
            let collectionC = UIStoryboard(name: "CollectionView", bundle: nil).instantiateInitialViewController()!
            collectionC.title = title
            self.show(collectionC, sender: nil)
        case 18:
            let coreAnimation = UIStoryboard(name: "CoreAnimation", bundle: nil).instantiateInitialViewController()!
            coreAnimation.title = title
            self.show(coreAnimation, sender: nil)
        case 19:
            let coreData = UIStoryboard(name: "CoreData", bundle: nil).instantiateInitialViewController()!
            coreData.title = title
            self.show(coreData, sender: nil)
        case 20:
            let coreImage = UIStoryboard(name: "CoreImage", bundle: nil).instantiateInitialViewController()!
            coreImage.title = title
            self.show(coreImage, sender: nil)
        case 21:
            let coreLocation = UIStoryboard(name: "Location", bundle: nil).instantiateInitialViewController()!
            coreLocation.title = title
            self.show(coreLocation, sender: nil)
        case 22:
            let photoGesture = UIStoryboard(name: "GestureForPhoto", bundle: nil).instantiateInitialViewController()!
            photoGesture.title = title
            self.show(photoGesture, sender: nil)
        case 23:
            let customKeyboard = UIStoryboard(name: "CustomKeyboard", bundle: nil).instantiateInitialViewController()!
            customKeyboard.title = title
            self.show(customKeyboard, sender: nil)
        case 24:
            let guidePage = AppGuideViewController()
            self.present(guidePage, animated: true, completion: nil)
        case 25:
            let bezierC = BezierViewController()
            bezierC.title = title
            self.show(bezierC, sender: nil)
        case 26:
            let layoutVFL = VFLViewController()
            layoutVFL.title = title
            self.show(layoutVFL, sender: nil)
        case 27:
            let cardGame = UIStoryboard(name: "CardGame", bundle: nil).instantiateInitialViewController()!
            cardGame.title = title
            self.show(cardGame, sender: nil)
        case 28:
            let poetry = UIStoryboard(name: "Poetry", bundle: nil).instantiateInitialViewController()!
            poetry.title = title
            self.show(poetry, sender: nil)
        case 29:
            let poetry = UIStoryboard(name: "JavaScriptCore", bundle: nil).instantiateInitialViewController()!
            poetry.title = title
            self.show(poetry, sender: nil)
        default:
            print("%s" + title, #function)
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }


}

