//
//  SettingsVC.swift
//  Guess
//
//  Created by Rene Dubrovski on 4/5/20.
//  Copyright © 2020 articga. All rights reserved.
//

import UIKit

class SettingsVC: UITableViewController {

    var userObj: NetworkService.User?
    
    var userNameCell = UITableViewCell()
    var userNameText = UITextField()
    
    var emailCell = UITableViewCell()
    var emailText = UITextField()
    

    override func loadView() {
        super.loadView()
        userNameText = UITextField(frame: userNameCell.contentView.bounds.insetBy(dx: 15, dy: 0))
        userNameText.isEnabled = false
        userNameCell.addSubview(userNameText)
        
        emailText = UITextField(frame: emailCell.contentView.bounds.insetBy(dx: 15, dy: 0))
        emailText.isEnabled = false
        emailCell.addSubview(emailText)
        
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.allowsSelection = false
    }
    
    override func viewDidLoad() {
        if let userName = userObj?.username, let email = userObj?.email {
            userNameText.text = userName.lowercased()
            emailText.text = email.lowercased()
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch(section) {
        case 0: return 2
        case 1: return 0
        default: fatalError("Unknown number of sections")
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch(indexPath.section) {
        case 0:
            switch(indexPath.row) {
            case 0: return userNameCell
            case 1: return emailCell
            default: fatalError("Unknown row in section 0")
            }
        default: fatalError("Unknown section")
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch(section) {
        case 0: return "Profile"
        case 1: return "Actions"
        default: fatalError("Unknown section")
        }
    }

}
