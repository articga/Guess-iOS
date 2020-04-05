//
//  ProfileDetailsViewController.swift
//  Guess
//
//  Created by Rene Dubrovski on 2/29/20.
//  Copyright © 2020 articga. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import KeychainAccess

class ProfileDetailsViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, NVActivityIndicatorViewable, NetworkServiceDelegate {
    
    func loginRequired() {
        service.showLogin(targetVC: self)
    }
    
    var pickedImage:UIImage?
    var service = NetworkService.sharedInstance
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
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
        service.delegate = self
        navigationItem.title = "My Profile"
        
        drawUIElements()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.layer.insertSublayer(generateBGGradient(), at: 0)
        
        let logOut = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: Selector(("logOut")))
        logOut.isEnabled = false
        navigationItem.rightBarButtonItem = logOut
        
        service.fetchLoggedInUser(onCompletion: { (user) in
            if let username = user.username {
                logOut.isEnabled = true
                self.usernameLabel.text = username
                
            }
            if let profileImgURL = user.profileImageIdentifier {
                self.profileImageView.imageFromUrl(urlString: "\(CDN_URL)\(profileImgURL)")
            }
        }) { (errString) in
            print(errString)
        }
        
    }
    
    func drawUIElements() {
        view.addSubview(profileImageView)
        view.addSubview(usernameLabel)
        
        profileImageView.image = UIImage(named: "placeholder_avatar")
        profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: Selector(("pickImage"))))
        
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0.0).isActive = true
        profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10.0).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 100.0).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 100.0).isActive = true
        
        usernameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0.0).isActive = true
        usernameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 10.0).isActive = true
    }
    
    @objc func logOut() {
        DispatchQueue.global(qos: .background).async {
            self.service.logOut()
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @objc func pickImage() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
        else {
            let alert  = UIAlertController(title: "Warning", message: "You don't have permission to access gallery.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage {
            self.profileImageView.image = image
            //Upload image
            let imgData = image.jpegData(compressionQuality: 0.5)!
            let service = NetworkService()
            service.uploadProfileImage(image: imgData) { (didUpload, serverMessage)  in
                if (didUpload) {
                    print(serverMessage)
                } else {
                    print(serverMessage)
                }
            }
            
        } else {
            print("No image")
        }

        picker.dismiss(animated: true, completion: nil)
    }
    
}
