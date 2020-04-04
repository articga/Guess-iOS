//
//  SummaryViewController.swift
//  Guess
//
//  Created by Rene Dubrovski on 4/4/20.
//  Copyright © 2020 articga. All rights reserved.
//

import UIKit

class SummaryVC: UIViewController {
    
    var score = 0 {
        didSet {
            scoreLabel.text = "\(score)"
        }
    }

    let scoreText: UILabel = {
       let label = UILabel()
       label.text = "Score"
       label.textColor = .white
       label.font = UIFont(name: "HelveticaNeue-Bold", size: 50.0)
       label.translatesAutoresizingMaskIntoConstraints = false
       return label
    }()
    
    let scoreLabel: UILabel = {
       let label = UILabel()
       label.text = "0"
       label.textColor = .white
       label.font = UIFont(name: "HelveticaNeue-Bold", size: 50.0)
       label.translatesAutoresizingMaskIntoConstraints = false
       return label
    }()
    
    let continueButton: UIButton = {
        let button = UIButton()
        button.setTitle("Dismiss", for: .normal)
        button.backgroundColor = UIColor(red: 0.03, green: 0.70, blue: 0.30, alpha: 1.00)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 23.0, weight: .medium)
        button.layer.cornerRadius = 6.0
        button.addTarget(self, action: #selector(doneButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        drawUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.layer.insertSublayer(generateBGGradient(), at: 0)
    }
    
    func drawUI() {
        view.addSubview(scoreText)
        view.addSubview(scoreLabel)
        view.addSubview(continueButton)
        
        scoreText.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10.0).isActive = true
        scoreText.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10.0).isActive = true
        scoreText.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10.0).isActive = true
        
        scoreLabel.topAnchor.constraint(equalTo: scoreText.bottomAnchor, constant: 15.0).isActive = true
        scoreLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10.0).isActive = true
        scoreLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10.0).isActive = true
        
        continueButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 5.0).isActive = true
        continueButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10.0).isActive = true
        continueButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10.0).isActive = true
        continueButton.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 11.0/75.0).isActive = true
    }
    
    @objc func doneButtonPressed() {
        view.window!.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
}
