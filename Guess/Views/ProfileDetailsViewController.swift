//
//  ProfileDetailsViewController.swift
//  Guess
//
//  Created by Rene Dubrovski on 2/29/20.
//  Copyright © 2020 articga. All rights reserved.
//

import UIKit

class ProfileDetailsViewController: UIViewController {

    var didRejectLogin = false
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "My Profile"
        
        drawUIElements()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.layer.insertSublayer(generateBGGradient(), at: 0)
        
        let logOut = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: Selector(("logOut")))
        logOut.isEnabled = false
        navigationItem.rightBarButtonItem = logOut
        
        let service = NetworkService()
        
        if (!didRejectLogin) {
            service.checkIfAuthenticated { (isAuth) in
                if (!isAuth) {
                    let vc = InitialLoadViewController()
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true) {
                        self.didRejectLogin = true
                    }
                }
            }
        }
        
        service.fetchLoggedInUser { (user, didSuccess) in
            if (didSuccess) {
                logOut.isEnabled = true
                self.usernameLabel.text = user.username
            }
        }
    }
    
    func drawUIElements() {
        view.addSubview(profileImageView)
        view.addSubview(usernameLabel)
        
        profileImageView.image = UIImage(named: "placeholder_avatar")
        
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0.0).isActive = true
        profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10.0).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 100.0).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 100.0).isActive = true
        
        usernameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0.0).isActive = true
        usernameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 10.0).isActive = true
    }
    
    
    @objc func logOut() {
        let service = NetworkService()
        service.logOut { (didLogOut) in
            if (didLogOut) {
                self.dismiss(animated: true, completion: nil)
            } else {
                //Show err alert
            }
        }
    }
    
}
