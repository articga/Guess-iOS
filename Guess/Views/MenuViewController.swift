//
//  ViewController.swift
//  Guess
//
//  Created by Rene Dubrovski on 10/31/19.
//  Copyright © 2019 articga. All rights reserved.
//

import UIKit
import Alamofire
import SocketIO

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let tableViewCellID = "modeCell"
    let modeTableView = UITableView()
    var tableViewData = [Quiz]()
    
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
        let segment = UISegmentedControl(items: ["Solo", "Matchmaking"])
        segment.selectedSegmentIndex = 0
        segment.addTarget(self, action: #selector(changeMode(sender:)), for: .valueChanged)
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
        //we dont need this checkAuth()
        drawUIElements()
        setUpTableView()
        
        navigationItem.title = "Mode Select"
        setProfileButton()
        
        updateTableView(mode: .offline)
    }
    
    func updateTableView(mode: QuizSession.FetchType) {
        let quizSession = QuizSession()
        tableViewData = quizSession.fetchModes(type: mode)
        modeTableView.reloadData()
    }
    
    func drawUIElements() {
        view.addSubview(modeSegmentControl)
        
        modeSegmentControl.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0.0).isActive = true
        modeSegmentControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 2.0).isActive = true
        modeSegmentControl.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 2.0).isActive = true
        modeSegmentControl.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -2.0).isActive = true
    }
    
    func checkAuth() {
        let service = NetworkService()
        service.checkIfAuthenticated { (isAuth) in
            if (!isAuth) {
                let vc = InitialLoadViewController()
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }
        }
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
        if tableViewData.count > 0 {
            modeTableView.backgroundView = nil
            return tableViewData.count
        } else {
            //Draw BG to tableview
            let image = UIImage(named: "empty")
            let noDataImage = UIImageView(image: image)
            noDataImage.contentMode = .scaleAspectFit
            noDataImage.translatesAutoresizingMaskIntoConstraints = false
            modeTableView.backgroundView = noDataImage
            noDataImage.centerXAnchor.constraint(equalTo: modeTableView.centerXAnchor, constant: 0.0).isActive = true
            noDataImage.centerYAnchor.constraint(equalTo: modeTableView.centerYAnchor, constant: 0.0).isActive = true
            noDataImage.widthAnchor.constraint(equalToConstant: 50.0).isActive = true
            return 0
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // this will turn on `masksToBounds` just before showing the cell
        cell.contentView.layer.masksToBounds = true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("SELECTED")
        let vc = QuizModeVC()
        vc.mode = tableViewData[indexPath.row].mode
        vc.modalPresentationStyle = .fullScreen
        DispatchQueue.main.async {
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableViewCellID, for: indexPath) as! ModeTableViewCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.modeTitleLabel.text = tableViewData[indexPath.row].title
        cell.descriptionLabel.text = tableViewData[indexPath.row].description
        cell.questionAmountLabel.text = "\(tableViewData[indexPath.row].questionAmount) Questions"
        return cell
    }
    
    @objc func launchProfileView() {
        let vc = ProfileDetailsViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func changeMode(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            updateTableView(mode: .offline)
            SocketService.default.closeConnection()
        case 1:
            updateTableView(mode: .online)
            SocketService.default.establishConnection()
        default:
            print("UNKNOWN SEGMENT")
        }
    }
    
    
}

