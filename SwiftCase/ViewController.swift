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
        switch indexPath.row {
        case 0:
            let airdrop = UIStoryboard.init(name: "Airdrop", bundle: nil).instantiateInitialViewController()!
            self.show(airdrop, sender: nil)
        default:
            print("%s" + list[indexPath.row], #function)
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }


}

