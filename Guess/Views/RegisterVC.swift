//
//  RegisterVC.swift
//  Guess
//
//  Created by Rene Dubrovski on 3/29/20.
//  Copyright © 2020 articga. All rights reserved.
//

import UIKit
import Alamofire
import KeychainAccess
import SkyFloatingLabelTextField
import NVActivityIndicatorView

class RegisterVC: UIViewController, NVActivityIndicatorViewable, UITextFieldDelegate {

    let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.isUserInteractionEnabled = true
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    let contentView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
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
    
    let userNameTextField: SkyFloatingLabelTextField = {
        let textField = SkyFloatingLabelTextField()
        textField.placeholder = "Username"
        textField.title = "Username"
        textField.textColor = .white
        textField.keyboardType = .default
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let emailTextField: SkyFloatingLabelTextField = {
        let textField = SkyFloatingLabelTextField()
        textField.placeholder = "Email"
        textField.title = "Email address"
        textField.textColor = .white
        textField.keyboardType = .emailAddress
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
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let repeatPasswordTextField: SkyFloatingLabelTextField = {
        let textField = SkyFloatingLabelTextField()
        textField.placeholder = "Repeat password"
        textField.title = "Repeat password"
        textField.isSecureTextEntry = true
        textField.keyboardAppearance = .dark
        textField.textColor = .white
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
        button.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
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
        view.addSubview(scrollView)
        scrollView.addSubview(fieldStackView)
        
        scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        fieldStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        fieldStackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        fieldStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        fieldStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        fieldStackView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        fieldStackView.heightAnchor.constraint(equalToConstant: 900.0).isActive = true
                
        fieldStackView.addSubview(bigQuestionMarkIcon)
        fieldStackView.addSubview(bigGuessText)
        fieldStackView.addSubview(smallInfoTextLabel)
        
        fieldStackView.addSubview(userNameTextField)
        fieldStackView.addSubview(emailTextField)
        fieldStackView.addSubview(passwordTextField)
        fieldStackView.addSubview(repeatPasswordTextField)
        fieldStackView.addSubview(continueButton)
        fieldStackView.addSubview(smallInfoBtn)
        
        /*
        fieldStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12.0).isActive = true
        fieldStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12.0).isActive = true
        fieldStackView.topAnchor.constraint(equalTo: smallInfoTextLabel.bottomAnchor, constant: 10.0).isActive = true
        fieldStackView.heightAnchor.constraint(equalToConstant: 250.0).isActive = true*/
        
        
        bigQuestionMarkIcon.centerXAnchor.constraint(equalTo: fieldStackView.centerXAnchor, constant: 0).isActive = true
        bigQuestionMarkIcon.topAnchor.constraint(equalTo: fieldStackView.topAnchor, constant: 5.0).isActive = true
        
        
        bigGuessText.centerXAnchor.constraint(equalTo: fieldStackView.centerXAnchor, constant: 0.0).isActive = true
        bigGuessText.topAnchor.constraint(equalTo: bigQuestionMarkIcon.bottomAnchor, constant: -10.0).isActive = true
        
        smallInfoTextLabel.centerXAnchor.constraint(equalTo: fieldStackView.centerXAnchor, constant: 0.0).isActive = true
        smallInfoTextLabel.topAnchor.constraint(equalTo: bigGuessText.bottomAnchor, constant: 3.0).isActive = true
        
        
        userNameTextField.topAnchor.constraint(equalTo: smallInfoTextLabel.topAnchor, constant: 20.0).isActive = true
        userNameTextField.leadingAnchor.constraint(equalTo: fieldStackView.leadingAnchor, constant: 10.0).isActive = true
        userNameTextField.trailingAnchor.constraint(equalTo: fieldStackView.trailingAnchor, constant: 10.0).isActive = true

        emailTextField.topAnchor.constraint(equalTo: userNameTextField.bottomAnchor, constant: 10.0).isActive = true
        emailTextField.leadingAnchor.constraint(equalTo: fieldStackView.leadingAnchor, constant: 10.0).isActive = true
        emailTextField.trailingAnchor.constraint(equalTo: fieldStackView.trailingAnchor, constant: 10.0).isActive = true
        
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 10.0).isActive = true
        passwordTextField.leadingAnchor.constraint(equalTo: fieldStackView.leadingAnchor, constant: 10.0).isActive = true
        passwordTextField.trailingAnchor.constraint(equalTo: fieldStackView.trailingAnchor, constant: 10.0).isActive = true
        
        repeatPasswordTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 10.0).isActive = true
        repeatPasswordTextField.leadingAnchor.constraint(equalTo: fieldStackView.leadingAnchor, constant: 10.0).isActive = true
        repeatPasswordTextField.trailingAnchor.constraint(equalTo: fieldStackView.trailingAnchor, constant: 10.0).isActive = true
        
        continueButton.leadingAnchor.constraint(equalTo: fieldStackView.leadingAnchor, constant: 12.0).isActive = true
        continueButton.trailingAnchor.constraint(equalTo: fieldStackView.trailingAnchor, constant: -12.0).isActive = true
        continueButton.heightAnchor.constraint(equalTo: fieldStackView.widthAnchor, multiplier: 11.0/75.0).isActive = true
        continueButton.topAnchor.constraint(equalTo: repeatPasswordTextField.bottomAnchor, constant: 15.0).isActive = true
        
        
        smallInfoBtn.centerXAnchor.constraint(equalTo: fieldStackView.centerXAnchor, constant: 0.0).isActive = true
        smallInfoBtn.topAnchor.constraint(equalTo: continueButton.bottomAnchor, constant: 10.0).isActive = true
        
    }
    
    override func viewWillLayoutSubviews(){
        super.viewWillLayoutSubviews()
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: 800)
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
                    //Dismiss all vc's in stack, go back to rootvc
                    self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
                    //Fallback
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
    
    @objc func handleRegister() {
        let netService = NetworkService()
        
        guard let username = userNameTextField.text, !username.isEmpty else {
            createAnnoyingAlert(withMessage: "Username is required")
            return
        }
        
        guard let email = emailTextField.text, !email.isEmpty else {
            createAnnoyingAlert(withMessage: "Email is required")
            return
        }
        
        guard let password = passwordTextField.text, !password.isEmpty else {
            createAnnoyingAlert(withMessage: "Password is required")
            return
        }
        
        guard let repassword = repeatPasswordTextField.text, !repassword.isEmpty else {
            createAnnoyingAlert(withMessage: "Missing information")
            return
        }
        
        if (repassword != password) {
            createAnnoyingAlert(withMessage: "Passwords don't match")
            return
        } else if (username.count < 6) {
            createAnnoyingAlert(withMessage: "Username must be at least 6 characters long")
            return
        } else if (password.count < 8) {
            createAnnoyingAlert(withMessage: "Password must be at least 8 characters long")
            return
        }
        
        netService.registerNewUser(username: username, email: email, password: password) { (didSuccess, serverMessage) in
            if (didSuccess) {
                let alert = UIAlertController(title: "Welcome", message: "Your account has been created, please verify your Email", preferredStyle: .alert)
                let action = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            } else {
                self.createAnnoyingAlert(withMessage: "Server side error: \(serverMessage)")
            }
        }
        
    }
    
    func createAnnoyingAlert(withMessage: String) {
        let alert = UIAlertController(title: "Error", message: withMessage, preferredStyle: .alert)
        let action = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    
    @objc func goBack() {
        dismiss(animated: true, completion: nil)
    }
    
    /*func drawUIElements() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        /*
        contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        contentView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true*/
                
        contentView.addSubview(bigQuestionMarkIcon)
        contentView.addSubview(bigGuessText)
        contentView.addSubview(smallInfoTextLabel)
        contentView.addSubview(fieldStackView)
        fieldStackView.addSubview(userNameTextField)
        fieldStackView.addSubview(emailTextField)
        fieldStackView.addSubview(passwordTextField)
        fieldStackView.addSubview(repeatPasswordTextField)
        fieldStackView.addSubview(continueButton)
        fieldStackView.addSubview(smallInfoBtn)
        
        fieldStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12.0).isActive = true
        fieldStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12.0).isActive = true
        fieldStackView.topAnchor.constraint(equalTo: smallInfoTextLabel.bottomAnchor, constant: 10.0).isActive = true
        fieldStackView.heightAnchor.constraint(equalToConstant: 250.0).isActive = true
        
        bigQuestionMarkIcon.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0).isActive = true
        bigQuestionMarkIcon.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 5.0).isActive = true
        
        bigGuessText.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0.0).isActive = true
        bigGuessText.topAnchor.constraint(equalTo: bigQuestionMarkIcon.bottomAnchor, constant: -10.0).isActive = true
        
        smallInfoTextLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0.0).isActive = true
        smallInfoTextLabel.topAnchor.constraint(equalTo: bigGuessText.bottomAnchor, constant: 3.0).isActive = true
        
        userNameTextField.topAnchor.constraint(equalTo: fieldStackView.topAnchor, constant: 0.0).isActive = true
        userNameTextField.leadingAnchor.constraint(equalTo: fieldStackView.leadingAnchor, constant: 0.0).isActive = true
        userNameTextField.rightAnchor.constraint(equalTo: fieldStackView.rightAnchor, constant: 0.0).isActive = true

        emailTextField.topAnchor.constraint(equalTo: userNameTextField.bottomAnchor, constant: 10.0).isActive = true
        emailTextField.leadingAnchor.constraint(equalTo: fieldStackView.leadingAnchor, constant: 0.0).isActive = true
        emailTextField.rightAnchor.constraint(equalTo: fieldStackView.rightAnchor, constant: 0.0).isActive = true
        
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 10.0).isActive = true
        passwordTextField.leadingAnchor.constraint(equalTo: fieldStackView.leadingAnchor, constant: 0.0).isActive = true
        passwordTextField.rightAnchor.constraint(equalTo: fieldStackView.rightAnchor, constant: 0.0).isActive = true
        
        repeatPasswordTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 10.0).isActive = true
        repeatPasswordTextField.leadingAnchor.constraint(equalTo: fieldStackView.leadingAnchor, constant: 0.0).isActive = true
        repeatPasswordTextField.rightAnchor.constraint(equalTo: fieldStackView.rightAnchor, constant: 0.0).isActive = true
        
        smallInfoBtn.centerXAnchor.constraint(equalTo: fieldStackView.centerXAnchor, constant: 0.0).isActive = true
        smallInfoBtn.topAnchor.constraint(equalTo: continueButton.bottomAnchor, constant: 5.0).isActive = true
        
        continueButton.leadingAnchor.constraint(equalTo: fieldStackView.leadingAnchor, constant: 12.0).isActive = true
        continueButton.rightAnchor.constraint(equalTo: fieldStackView.rightAnchor, constant: -12.0).isActive = true
        continueButton.heightAnchor.constraint(equalTo: fieldStackView.widthAnchor, multiplier: 11.0/75.0).isActive = true
        continueButton.topAnchor.constraint(equalTo: repeatPasswordTextField.bottomAnchor, constant: 15.0).isActive = true
        
    }*/
}
