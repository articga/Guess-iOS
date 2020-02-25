//
//  LogInVC.swift
//  Guess
//
//  Created by Rene Dubrovski on 2/25/20.
//  Copyright © 2020 articga. All rights reserved.
//
//  Handle user login with password

import UIKit
import Alamofire
import KeychainAccess
import SkyFloatingLabelTextField
import NVActivityIndicatorView

class LogInVC: UIViewController, NVActivityIndicatorViewable {
    
    let bigQuestionMarkIcon: UILabel = {
           let label = UILabel()
           label.text = "?"
           label.textColor = .white
           label.font = UIFont(name: "HelveticaNeue-Medium", size: 200.0)
           label.translatesAutoresizingMaskIntoConstraints = false
           return label
       }()
       
    let bigGuessText: UILabel = {
       let label = UILabel()
       label.text = "GUESS"
       label.textColor = .white
       label.font = UIFont(name: "HelveticaNeue-Bold", size: 50.0)
       label.translatesAutoresizingMaskIntoConstraints = false
       return label
    }()

    let smallInfoTextLabel: UILabel = {
       let label = UILabel()
       label.text = "Solve miniature quizzes"
       label.textColor = .white
       label.font = UIFont(name: "HelveticaNeue-Bold", size: 18.0)
       label.translatesAutoresizingMaskIntoConstraints = false
       return label
    }()
    
    let fieldStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 16.0
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let emailTextField: SkyFloatingLabelTextField = {
        let textField = SkyFloatingLabelTextField()
        textField.placeholder = "Email"
        textField.title = "Email address"
        textField.textColor = .white
        textField.keyboardType = .emailAddress
        textField.text = "rene@dubrovski.eu"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let passwordTextField: SkyFloatingLabelTextField = {
        let textField = SkyFloatingLabelTextField()
        textField.placeholder = "Password"
        textField.title = "Password"
        textField.isSecureTextEntry = true
        textField.keyboardAppearance = .dark
        textField.textColor = .white
        textField.text = "123qwertyA"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let continueButton: UIButton = {
        let button = UIButton()
        button.setTitle("Continue", for: .normal)
        button.backgroundColor = UIColor(red: 0.03, green: 0.70, blue: 0.30, alpha: 1.00)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 23.0, weight: .medium)
        button.layer.cornerRadius = 6.0
        button.addTarget(self, action: #selector(handleLogIn), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let smallInfoBtn: UIButton = {
        let button = UIButton()
        button.setTitle("Go back to previous page", for: .normal)
        button.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        button.setTitleColor(UIColor(red: 1.00, green: 0.69, blue: 0.17, alpha: 1.00), for: .normal)
        button.backgroundColor = .clear
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        drawUIElements()
        hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.layer.insertSublayer(generateBGGradient(), at: 0)
    }
    
    func drawUIElements() {
        view.addSubview(bigQuestionMarkIcon)
        view.addSubview(bigGuessText)
        view.addSubview(smallInfoTextLabel)
        view.addSubview(emailTextField)
        view.addSubview(fieldStackView)
        view.addSubview(continueButton)
        view.addSubview(smallInfoBtn)
        fieldStackView.addSubview(emailTextField)
        fieldStackView.addSubview(passwordTextField)
        
        bigQuestionMarkIcon.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        bigQuestionMarkIcon.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5.0).isActive = true
        
        bigGuessText.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0.0).isActive = true
        bigGuessText.topAnchor.constraint(equalTo: bigQuestionMarkIcon.bottomAnchor, constant: -10.0).isActive = true
        
        smallInfoTextLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0.0).isActive = true
        smallInfoTextLabel.topAnchor.constraint(equalTo: bigGuessText.bottomAnchor, constant: 3.0).isActive = true
        
        fieldStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        fieldStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        //fieldStackView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 10.0).isActive = true
        //fieldStackView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -10.0).isActive = true
        fieldStackView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 1.3).isActive = true
        fieldStackView.heightAnchor.constraint(equalToConstant: 120.0).isActive = true

        emailTextField.topAnchor.constraint(equalTo: fieldStackView.topAnchor, constant: 0.0).isActive = true
        emailTextField.leftAnchor.constraint(equalTo: fieldStackView.leftAnchor, constant: 0.0).isActive = true
        emailTextField.rightAnchor.constraint(equalTo: fieldStackView.rightAnchor, constant: 0.0).isActive = true
        
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 10.0).isActive = true
        passwordTextField.leftAnchor.constraint(equalTo: fieldStackView.leftAnchor, constant: 0.0).isActive = true
        passwordTextField.rightAnchor.constraint(equalTo: fieldStackView.rightAnchor, constant: 0.0).isActive = true
        
        smallInfoBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0.0).isActive = true
        smallInfoBtn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 5.0).isActive = true
        
        continueButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        continueButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 12.0).isActive = true
        continueButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -12.0).isActive = true
        continueButton.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 11.0/75.0).isActive = true
        continueButton.bottomAnchor.constraint(equalTo: smallInfoBtn.topAnchor, constant: -10.0).isActive = true
    }
    
    @objc func handleLogIn() {
        //Code for handling user login
        let netService = NetworkService()
        
        if (emailTextField.text != "" && passwordTextField.text != "") {
            let size = CGSize(width: 50, height: 50)
            startAnimating(size, message: "Logging in", type: .ballScaleMultiple)
            
            netService.authenticateUser(email: emailTextField.text!, password: passwordTextField.text!) { (isAuth) in
                self.stopAnimating()
                if (isAuth) {
                    //Push to next VC
                    self.dismiss(animated: true, completion: nil)
                } else {
                    //Display error
                    let alert = UIAlertController(title: "Login Error", message: "Incorrect credentials", preferredStyle: .alert)
                    let action = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
                    alert.addAction(action)
                    self.present(alert, animated: true) {
                        self.passwordTextField.text = ""
                    }
                }
            }
        } else {
            //TODO - Implement real time field check
        }
    }
    
    @objc func goBack() {
        dismiss(animated: true, completion: nil)
    }
}
