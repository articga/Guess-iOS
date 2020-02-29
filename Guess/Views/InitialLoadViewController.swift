//
//  InitialLoadViewController.swift
//  Guess
//
//  Created by Rene Dubrovski on 2/23/20.
//  Copyright © 2020 articga. All rights reserved.
//
// Presented when the app is opened first time, allows user to sign in with apple ID

import UIKit
import AuthenticationServices

class InitialLoadViewController: UIViewController, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
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
    
    let emailPasswordLoginModeButton: UIButton = {
        let button = UIButton()
        button.setTitle("Authenitcate with Email", for: .normal)
        button.backgroundColor = UIColor(red: 0.03, green: 0.70, blue: 0.30, alpha: 1.00)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 23.0, weight: .medium)
        button.layer.cornerRadius = 6.0
        button.addTarget(self, action: #selector(handleLoginWithEmail), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let appleLogInButton: ASAuthorizationAppleIDButton = {
        let button = ASAuthorizationAppleIDButton(type: ASAuthorizationAppleIDButton.ButtonType.default, style: ASAuthorizationAppleIDButton.Style.white)
        button.addTarget(self, action: #selector(handleLogInWithAppleID), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let smallInfoBtn: UIButton = {
        let button = UIButton()
        button.setTitle("or continue without signing in", for: .normal)
        button.addTarget(self, action: #selector(continuWithoutSigningIn), for: .touchUpInside)
        button.setTitleColor(UIColor(red: 1.00, green: 0.69, blue: 0.17, alpha: 1.00), for: .normal)
        button.backgroundColor = .clear
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        drawUIElements()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.layer.insertSublayer(generateBGGradient(), at: 0)
    }
    
    func drawUIElements() {
        view.addSubview(appleLogInButton)
        view.addSubview(bigQuestionMarkIcon)
        view.addSubview(bigGuessText)
        view.addSubview(smallInfoTextLabel)
        view.addSubview(emailPasswordLoginModeButton)
        view.addSubview(smallInfoBtn)
        
        smallInfoBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0.0).isActive = true
        smallInfoBtn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 5.0).isActive = true
        
        appleLogInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        appleLogInButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 12.0).isActive = true
        appleLogInButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -12.0).isActive = true
        appleLogInButton.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 11.0/75.0).isActive = true
        appleLogInButton.bottomAnchor.constraint(equalTo: smallInfoBtn.topAnchor, constant: -10.0).isActive = true
        
        emailPasswordLoginModeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emailPasswordLoginModeButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 12.0).isActive = true
        emailPasswordLoginModeButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -12.0).isActive = true
        emailPasswordLoginModeButton.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 11.0/75.0).isActive = true
        emailPasswordLoginModeButton.bottomAnchor.constraint(equalTo: appleLogInButton.topAnchor, constant: -10.0).isActive = true
        
        bigQuestionMarkIcon.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        bigQuestionMarkIcon.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5.0).isActive = true
        
        bigGuessText.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0.0).isActive = true
        bigGuessText.topAnchor.constraint(equalTo: bigQuestionMarkIcon.bottomAnchor, constant: -10.0).isActive = true
        
        smallInfoTextLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0.0).isActive = true
        smallInfoTextLabel.topAnchor.constraint(equalTo: bigGuessText.bottomAnchor, constant: 3.0).isActive = true
    }
    
    @objc func continuWithoutSigningIn() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleLogInWithAppleID() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        
        controller.delegate = self
        controller.presentationContextProvider = self
        
        controller.performRequests()

    }
    
    @objc func handleLoginWithEmail() {
        let vc = LogInVC()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            let userIdentifier = appleIDCredential.user
        
            print("User ID: \(userIdentifier)")
            
            //Save the UserIdentifier somewhere in your server/database
            //Push to next viewcontroller
            
            break
        default:
            break
            
        }
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
