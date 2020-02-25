//
//  SettingsTableViewController.swift
//  Guess
//
//  Created by Rene Dubrovski on 2/11/20.
//  Copyright © 2020 articga. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    let aboutCell = UITableViewCell()
    var aboutButton: UIButton = {
        let button = UIButton()
        button.setTitle("About", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Settings"
        tableView = UITableView.init(frame: CGRect.zero, style: .grouped)
        aboutCell.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
        
        drawUIElements()
    }
    
    func drawUIElements() {
        aboutButton.frame = aboutCell.frame
        aboutCell.addSubview(aboutButton)
        
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch(section) {
        case 0: return 1    // section 0 has 2 rows
        default: fatalError("Unknown number of sections")
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch(indexPath.section) {
        case 0:
            switch(indexPath.row) {
            case 0: return self.aboutCell   // section 0, row 0 is the about cell
            default: fatalError("Unknown row in section 0")
            }
        default: fatalError("Unknown section")
        }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch(section) {
        case 0: return "Other"
        default: fatalError("Unknown section")
        }
    }

}
