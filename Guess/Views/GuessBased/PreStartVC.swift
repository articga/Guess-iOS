//
//  PreStartVC.swift
//  Guess
//
//  Created by Rene Dubrovski on 4/5/20.
//  Copyright © 2020 articga. All rights reserved.
//

import UIKit

class PreStartVC: UIViewController {

    var quiz: Quiz = Quiz(mode: .unspecified, title: "", description: "", questionAmount: 0, imageTitle: "", boxColor: .clear)
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Title"
        label.textColor = .white
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 82.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let questionsIndicationLabel: UILabel = {
        let label = UILabel()
        label.text = "Questions"
        label.textColor = .white
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 42)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Description"
        label.textColor = .white
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 24.0)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let continueButton: UIButton = {
        let button = UIButton()
        button.setTitle("Start", for: .normal)
        button.backgroundColor = UIColor(red: 0.03, green: 0.70, blue: 0.30, alpha: 1.00)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 23.0, weight: .medium)
        button.layer.cornerRadius = 6.0
        button.addTarget(self, action: #selector(start), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        renderUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.layer.insertSublayer(generateBGGradient(), at: 0)
    }
    
    func renderUI() {
        view.addSubview(titleLabel)
        view.addSubview(questionsIndicationLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(continueButton)
        
        titleLabel.text = quiz.title
        questionsIndicationLabel.text = "Questions \(quiz.questionAmount)"
        descriptionLabel.text = quiz.description
        
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10.0).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 6.0).isActive = true
        
        questionsIndicationLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10.0).isActive = true
        questionsIndicationLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 6.0).isActive = true
        
        descriptionLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 0.0).isActive = true
        descriptionLabel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: 0.0).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 12.0).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -12.0).isActive = true
        
        continueButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15.0).isActive = true
        continueButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 0.0).isActive = true
        continueButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 12.0).isActive = true
        continueButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -12.0).isActive = true
        continueButton.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 11.0/75.0).isActive = true
    }
    
    @objc func start() {
        let vc = QuizModeVC()
        vc.modalPresentationStyle = .fullScreen
        vc.mode = self.quiz.mode
        DispatchQueue.main.async {
            self.present(vc, animated: true, completion: nil)
        }
    }
    
}
