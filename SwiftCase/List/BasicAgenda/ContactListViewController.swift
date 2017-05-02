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
    
    convenience init() {
        self.init(avatarURL: "", name: "", surname: "", phone: "", email: "")
    }
    
    init(avatarURL: String?, name: String?, surname: String?, phone: String?, email: String?) {
        self.avatarURL = avatarURL ?? ""
        self.name = name ?? ""
        self.surname = surname ?? ""
        self.phone = phone ?? ""
        self.email = email ?? ""
    }
}

class ContactCell: UITableViewCell {
    
}

class ContactListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var contactArr = [Contact]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addSourceCodeItem("contactlist")
        
        for i in 1...30 {
            let contact = Contact(avatarURL: "image", name: "Name\(i)", surname: "Surname\(i)", phone: "13135674942", email: "powerwtf@live.com")
            contactArr.append(contact)
        }
        
    }
    
    // MARK: - UITableViewDelegate, UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ContactCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "contactDetail" {
            let detailC = segue.destination as! ContactDetailViewController
            
        } else if segue.identifier == "addContact" {
            
        }
    }

}
