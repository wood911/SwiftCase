//
//  ContactListViewController.swift
//  SwiftCase
//
//  Created by 伍腾飞 on 2017/4/30.
//  Copyright © 2017年 Shepherd. All rights reserved.
//

import UIKit

class Contact {
    var avatarURL: String
    var name: String
    var surname: String
    var phone: String
    var email: String
    // 便捷构造器 调用其他初始化方法进行初始化
//    convenience init() {
//        self.init(avatarURL: "", name: "", surname: "", phone: "", email: "")
//    }
    init() {
        avatarURL = ""
        name = ""
        surname = ""
        phone = ""
        email = ""
    }
    // 不声明构造器时，编译器提供默认构造器init()，当声明构造器后，编译器不再提供
    init(avatarURL: String?, name: String?, surname: String?, phone: String?, email: String?) {
        // 空合运算符 name ?? defaultValue 当name==false时给默认值
        self.avatarURL = avatarURL ?? ""
        self.name = name ?? ""
        self.surname = surname ?? ""
        self.phone = phone ?? ""
        self.email = email ?? ""
    }
}

class ContactCell: UITableViewCell {
    @IBOutlet private weak var icon: UIImageView!
    @IBOutlet private weak var name: UILabel!
    @IBOutlet private weak var phone: UILabel!
    
    private var _contact: Contact?
    var contact: Contact! {
        set {
            _contact = newValue
            icon = UIImageView.init(image: UIImage.init(named: newValue.avatarURL))
            name.text = newValue.name
            phone.text = newValue.phone
        }
        get {
            return _contact
        }
        // Objective-C -> add observer
//        willSet (newContact) {
//            print("\(newContact.name) \(newContact.phone)")
//        }
//        didSet {
//            
//        }
    }
    
}

class ContactListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NewContactDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var contactArr = [Contact]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(toAddContact))
        self.addSourceCodeItem("contactlist")
        
        for i in 1...30 {
            let contact = Contact(avatarURL: "image", name: "Name\(i)", surname: "Surname\(i)", phone: "4008008888", email: "developer@icloud.com")
            contactArr.append(contact)
        }
        
        tableView.estimatedRowHeight = 48
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    // MARK: - UITableViewDelegate, UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ContactCell
        cell.contact = contactArr[indexPath.row]
        cell.tag = indexPath.row
        return cell
    }
    
    // MARK: - Add Contact
    @objc func toAddContact() {
        let naviC = UIStoryboard.init(name: "BasicAgenda", bundle: nil).instantiateViewController(withIdentifier: "addContact") as! UINavigationController
        (naviC.viewControllers[0] as! ContactAddViewController).delegate = self
        self.present(naviC, animated: true, completion: nil)
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "contactDetail" {
            let detailC = segue.destination as! ContactDetailViewController
            // (sender as! ContactCell).contact
            let contact = contactArr[(sender as! ContactCell).tag]
            detailC.contact = contact
        }
    }
    
    // MARK: - NewContactDelegate
    func newContact(_ contact: Contact) {
        contactArr.append(contact)
        tableView.reloadData()
    }

}
