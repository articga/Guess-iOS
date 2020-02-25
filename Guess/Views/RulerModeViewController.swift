//
//  RulerModeViewController.swift
//  Guess
//
//  Created by Rene Dubrovski on 10/31/19.
//  Copyright © 2019 articga. All rights reserved.
//

import UIKit

enum GuessModes {
    case Ruler
    case Random
}

class RulerModeViewController: UIViewController {
    //Generate a line random pixel
    //Let user enter it and guess
    
    let lineUIView: RulerModeLineGenerator = {
        let view = RulerModeLineGenerator()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .gray
        return view
    }()
    
    let answerTextField: UITextField = {
        let textField = UITextField()
        textField.keyboardType = .decimalPad
        textField.textColor = .blue
        textField.backgroundColor = .gray
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let submitButton: UIButton = {
        let button = UIButton()
        button.setTitle("Continue", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.backgroundColor = .red
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        drawUIElements()
        self.hideKeyboardWhenTappedAround()
    }
    
    func drawUIElements() {
        view.addSubview(lineUIView)
        view.addSubview(answerTextField)
        view.addSubview(submitButton)
        
        submitButton.addTarget(self, action: #selector(submitPressed), for: .touchUpInside)
        
        lineUIView.topAnchor.constraint(equalTo: view.topAnchor, constant: 30.0).isActive = true
        lineUIView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20.0).isActive = true
        lineUIView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20.0).isActive = true
        //Keep a 16:9 on every device
        lineUIView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 9.0/16.0).isActive = true
        
        answerTextField.topAnchor.constraint(equalTo: lineUIView.bottomAnchor, constant: 20.0).isActive = true
        answerTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20.0).isActive = true
        answerTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20.0).isActive = true
        
        submitButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -15.0).isActive = true
        submitButton.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1.0/8.0).isActive = true
        submitButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10.0).isActive = true
        submitButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10.0).isActive = true
        
    }
    
    @objc func submitPressed() {
        //Calculate result
        
        //Error causing
        let result = lineUIView.getResults(guess: Double(answerTextField.text!) as! Double)
        let alert = UIAlertController(title: "Results", message: "Percentage error: \(result) % \n Correct answer: \(lineUIView.returnCorrectAnswer())", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
        //Clear textfield and render a new result
        answerTextField.text = ""
        lineUIView.setNeedsDisplay()
    }

}
