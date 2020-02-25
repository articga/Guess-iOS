//
//  ViewController.swift
//  Guess
//
//  Created by Rene Dubrovski on 10/31/19.
//  Copyright © 2019 articga. All rights reserved.
//

import UIKit
import Alamofire

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let tableViewCellID = "modeCell"
    let modeTableView = UITableView()
    
    
    let rulerModeButton: UIButton = {
        let button = UIButton()
        button.setTitle("Ruler", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let factsModeButton: UIButton = {
        let button = UIButton()
        button.setTitle("Facts", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let modeSegmentControl: UISegmentedControl = {
        let segment = UISegmentedControl(items: ["Solo", "Friends"])
        segment.selectedSegmentIndex = 0
        segment.translatesAutoresizingMaskIntoConstraints = false
        return segment
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.layer.insertSublayer(generateBGGradient(), at: 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        drawUIElements()
        setUpTableView()
        navigationItem.title = "Mode Select"
        setProfileButton()
    }
    
    func drawUIElements() {
        view.addSubview(modeSegmentControl)
        
        modeSegmentControl.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0.0).isActive = true
        modeSegmentControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 2.0).isActive = true
        modeSegmentControl.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 2.0).isActive = true
        modeSegmentControl.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -2.0).isActive = true
    }
    
    func setProfileButton() {
        let avatarSize: CGFloat = 30
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: avatarSize, height: avatarSize)
        button.setImage(UIImage(named: "placeholder_avatar")?.resizeImage(avatarSize, opaque: false), for: .normal)
        button.addTarget(self, action: #selector(launchProfileView), for: .touchUpInside)

        if let buttonImageView = button.imageView {
            button.imageView?.layer.cornerRadius = buttonImageView.frame.size.width / 2
            button.imageView?.clipsToBounds = true
            button.imageView?.contentMode = .scaleAspectFit
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
    }

    func setUpTableView() {
        modeTableView.backgroundColor = .clear
        modeTableView.register(ModeTableViewCell.self, forCellReuseIdentifier: tableViewCellID)
        modeTableView.separatorStyle = .none
        modeTableView.dataSource = self
        modeTableView.delegate = self
        modeTableView.rowHeight = 100.0
        view.addSubview(modeTableView)
        modeTableView.translatesAutoresizingMaskIntoConstraints = false
        modeTableView.topAnchor.constraint(equalTo: modeSegmentControl.bottomAnchor, constant: 1.0).isActive = true
        modeTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        modeTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        modeTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // this will turn on `masksToBounds` just before showing the cell
        cell.contentView.layer.masksToBounds = true
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableViewCellID, for: indexPath) as! ModeTableViewCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.modeTitleLabel.text = "Ruler"
        cell.descriptionLabel.text = "Guess the line length"
        cell.questionAmountLabel.text = "10 Questions"
        return cell
    }
    
    @objc func rulerModeClicked() {
        let rulerModeContoller = RulerModeViewController()
        rulerModeContoller.modalPresentationStyle = .fullScreen
        present(rulerModeContoller, animated: true, completion: nil)
    }
    
    @objc func launchProfileView() {
        print("Profile launch")
    }
    
    @objc func factsModeButtonClicked() {
        factsModeButton.setTitle(":(", for: .normal)
    }
    
    
    
    
}

