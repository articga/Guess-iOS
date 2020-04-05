//
//  RulerModeViewController.swift
//  Guess
//
//  Created by Rene Dubrovski on 10/31/19.
//  Copyright © 2019 articga. All rights reserved.
//
//  Reusable view for quiz

import UIKit
import CoreHaptics
import CoreData
import NVActivityIndicatorView
import SkyFloatingLabelTextField
import Haptica

class QuizModeVC: UIViewController, NVActivityIndicatorViewable, CountryModeDelegate, RulerModeDelegate {
        
    var context: NSManagedObjectContext!
    //Mode, user selected
    var mode: QuizSession.QuizMode = .unspecified
    
    let timePerQuestion = 10
    var totalTime = 10 {
        didSet {
            timerLabel.text = "\(timeFormatted(totalTime))"
        }
    }
    var questionInHand = 1 {
        didSet {
            questionStepLabel.text = "\(questionInHand)/10"
        }
    }
    
    var score = 0 {
        didSet {
            pointsLabel.text = "\(score)"
        }
    }
    
    let pointsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 28.0)
        label.textAlignment = .left
        label.text = "0"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let questionStepLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 28.0)
        label.text = "1/10"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let timerLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 28.0)
        label.text = "00:10"
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let scoreBoardStackView: UIStackView = {
        let stackView = UIStackView()
        //stackView.spacing = 1.0
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        //openDatabse()
        
        if (mode == .ruler) {
            answerTextField.becomeFirstResponder()
            drawUIElementsForRuler()
        } else if (mode == .country) {
            drawUIForCountry()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.layer.insertSublayer(generateBGGradient(), at: 0)
    }
    
    //MARK: - Ruler
    lazy var lineUIView: RulerModeLineGenerator = {
        let view = RulerModeLineGenerator()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.delegate = self as RulerModeDelegate
        return view
    }()
    
    let answerTextField: SkyFloatingLabelTextField = {
        let textField = SkyFloatingLabelTextField()
        textField.keyboardType = .decimalPad
        textField.keyboardAppearance = .dark
        textField.placeholder = "Guess"
        textField.title = "Guess"
        textField.textColor = .white
        textField.titleColor = .white
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let submitButton: UIButton = {
        let button = UIButton()
        button.setTitle("Next", for: .normal)
        button.backgroundColor = UIColor(red: 0.03, green: 0.70, blue: 0.30, alpha: 1.00)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 23.0, weight: .medium)
        button.layer.cornerRadius = 6.0
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    func drawUIElementsForRuler() {
        lineUIView.initateView(questionAmount: 10, timePerQuestion: 10)
        view.addSubview(lineUIView)
        view.addSubview(answerTextField)
        view.addSubview(submitButton)
        scoreBoardStackView.addArrangedSubview(pointsLabel)
        scoreBoardStackView.addArrangedSubview(questionStepLabel)
        scoreBoardStackView.addArrangedSubview(timerLabel)
        view.addSubview(scoreBoardStackView)
        

        submitButton.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
        
        scoreBoardStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5.0).isActive = true
        scoreBoardStackView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 10.0).isActive = true
        scoreBoardStackView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -10.0).isActive = true
        
        lineUIView.topAnchor.constraint(equalTo: scoreBoardStackView.bottomAnchor, constant: 15.0).isActive = true
        lineUIView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 10.0).isActive = true
        lineUIView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -10.0).isActive = true
        //Keep a 16:9 on every device
        lineUIView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 9.0/16.0).isActive = true
        
        answerTextField.topAnchor.constraint(equalTo: lineUIView.bottomAnchor, constant: 5.0).isActive = true
        answerTextField.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 10.0).isActive = true
        answerTextField.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -10.0).isActive = true
        
        submitButton.topAnchor.constraint(equalTo: answerTextField.bottomAnchor, constant: 10.0).isActive = true
        submitButton.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 1.0/8.0).isActive = true
        submitButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 10.0).isActive = true
        submitButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -10.0).isActive = true
    }
    
    @objc func handleSubmit() {
        if answerTextField.text != nil && answerTextField.text != "" {
            if let answer = answerTextField.text {
                lineUIView.submitAnswer(answer: answer)
                answerTextField.text = ""
                lineUIView.setNeedsDisplay()
            }
        }
    }
    
    //MARK: - World
    lazy var mapController: CountryModeGenerator = {
        let mC = CountryModeGenerator()
        mC.delegate = self as CountryModeDelegate
        mC.translatesAutoresizingMaskIntoConstraints = false
        return mC
    }()
    
    let guideText: UILabel = {
        let t = UILabel()
        t.text = "Choose the correct area for <loading>"
        t.textColor = .white
        t.font = UIFont(name: "HelveticaNeue-Bold", size: 16.0)
        t.numberOfLines = 2
        t.textAlignment = .center
        t.translatesAutoresizingMaskIntoConstraints = false
        return t
    }()
    
    let answerButton1: UIButton = {
        let button = UIButton()
        button.tag = 0
        button.setTitle("", for: .normal)
        button.backgroundColor = UIColor(red: 0.03, green: 0.70, blue: 0.30, alpha: 1.00)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 23.0, weight: .medium)
        button.layer.cornerRadius = 6.0
        button.addTarget(self, action: #selector(handleSendForWorld(sender:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let answerButton2: UIButton = {
        let button = UIButton()
        button.tag = 1
        button.setTitle("", for: .normal)
        button.backgroundColor = UIColor(red: 0.03, green: 0.70, blue: 0.30, alpha: 1.00)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 23.0, weight: .medium)
        button.layer.cornerRadius = 6.0
        button.addTarget(self, action: #selector(handleSendForWorld(sender:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let answerButton3: UIButton = {
        let button = UIButton()
        button.tag = 2
        button.setTitle("", for: .normal)
        button.backgroundColor = UIColor(red: 0.03, green: 0.70, blue: 0.30, alpha: 1.00)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 23.0, weight: .medium)
        button.layer.cornerRadius = 6.0
        button.addTarget(self, action: #selector(handleSendForWorld(sender:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    func drawUIForCountry() {
        mapController.initiateView(questionAmount: 10)
        scoreBoardStackView.addArrangedSubview(pointsLabel)
        scoreBoardStackView.addArrangedSubview(questionStepLabel)
        scoreBoardStackView.addArrangedSubview(timerLabel)
        view.addSubview(scoreBoardStackView)
        
        scoreBoardStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5.0).isActive = true
        scoreBoardStackView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 10.0).isActive = true
        scoreBoardStackView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -10.0).isActive = true
        
        view.addSubview(mapController)
        view.addSubview(guideText)
        view.addSubview(answerButton1)
        view.addSubview(answerButton2)
        view.addSubview(answerButton3)
        
        guideText.topAnchor.constraint(equalTo: scoreBoardStackView.bottomAnchor, constant: 10.0).isActive = true
        guideText.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        mapController.topAnchor.constraint(equalTo: guideText.bottomAnchor, constant: 10.0).isActive = true
        mapController.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 10.0).isActive = true
        mapController.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -10.0).isActive = true
        //Keep a 16:9 on every device
        mapController.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 9.0/16.0).isActive = true
        
        answerButton1.topAnchor.constraint(equalTo: mapController.bottomAnchor, constant: 10.0).isActive = true
        answerButton1.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 1.0/8.0).isActive = true
        answerButton1.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 10.0).isActive = true
        answerButton1.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -10.0).isActive = true
        
        answerButton2.topAnchor.constraint(equalTo: answerButton1.bottomAnchor, constant: 10.0).isActive = true
        answerButton2.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 1.0/8.0).isActive = true
        answerButton2.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 10.0).isActive = true
        answerButton2.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -10.0).isActive = true
        
        answerButton3.topAnchor.constraint(equalTo: answerButton2.bottomAnchor, constant: 10.0).isActive = true
        answerButton3.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 1.0/8.0).isActive = true
        answerButton3.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 10.0).isActive = true
        answerButton3.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -10.0).isActive = true
    }
    
    @objc func handleSendForWorld(sender: UIButton) {
        mapController.chooseOption(optionID: sender.tag)
    }
    
    func selectedCountry(country: CountryModeGenerator.Country) {
        guideText.text = "Choose the correct area for \(country.name!)"
    }
    
    func options(options: [Int]) {
        answerButton1.setTitle("\(options[0]) sq/km", for: .normal)
        answerButton2.setTitle("\(options[1]) sq/km", for: .normal)
        answerButton3.setTitle("\(options[2]) sq/km", for: .normal)
    }
    
    func indexIncremented(newIndex: Int) {
        questionStepLabel.text = "\(newIndex)/10"
    }
    
    func scoreGenerated(newScoreAmount: Int) {
        pointsLabel.text = "\(newScoreAmount)"
    }
    
    func timeValueChanged(newValue: Int) {
        timerLabel.text = "\(timeFormatted(newValue))"
    }
    
    func labelShouldBeRed(isTrue: Bool) {
        if (isTrue) {
            timerLabel.textColor = .red
        } else {
            timerLabel.textColor = .white
        }
    }
    
    func quizEnded() {
        let vc = SummaryVC()
        vc.score = Int(pointsLabel.text!)!
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    //MARK: - Functions
    
    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
        
    func openDatabse() {
        
    }
    
    func fetchHighScore() {
        print("Fetching Data..")
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "LocalUserData")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                let userName = data.value(forKey: "username") as! String
                let age = data.value(forKey: "age") as! String
                print("User Name is : "+userName+" and Age is : "+age)
            }
        } catch {
            print("Fetching data Failed")
        }
    }

}
