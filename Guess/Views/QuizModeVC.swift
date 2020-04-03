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

class QuizModeVC: UIViewController, NVActivityIndicatorViewable {
    
    var context: NSManagedObjectContext!
    
    //Mode, user selected
    var mode: QuizSession.QuizMode = .unspecified
    var countdownTimer: Timer!
    var totalTime = 60 //In seconds
    var questionInHand = 1 {
        didSet {
            questionStepLabel.text = "\(questionInHand)/10"
        }
    }
    
    var score = 0 {
        didSet {
            pointsLabel.text = "\(score) pts"
        }
    }
    
    let pointsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 28.0)
        label.text = "0 pts"
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
        label.text = "01:00"
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let scoreBoardStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 1.0
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let lineUIView: RulerModeLineGenerator = {
        let view = RulerModeLineGenerator()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        //openDatabse()
        answerTextField.becomeFirstResponder()
        
        if (mode == .ruler) {
            drawUIElementsForRuler()
        } else if (mode == .ruler_online) {
            setUPMatchMaking()
            //drawUIElementsForRulerOnline()
        } else if (mode == .country) {
            //Draw for country
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.layer.insertSublayer(generateBGGradient(), at: 0)
    }
    
    @objc func updateTimer() {
        timerLabel.text = "\(timeFormatted(totalTime))"
        
        if totalTime != 0 {
            totalTime -= 1
        } else if 1 ... 3 ~= totalTime {
            //MARK: - Generate warning (TODO)
            print("Called")
        } else {
            countdownTimer.invalidate()
            quizOver()
        }
    }

    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        //     let hours: Int = totalSeconds / 3600
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    func drawUIElementsForRuler() {
        view.addSubview(lineUIView)
        view.addSubview(answerTextField)
        view.addSubview(submitButton)
        scoreBoardStackView.addArrangedSubview(pointsLabel)
        scoreBoardStackView.addArrangedSubview(questionStepLabel)
        scoreBoardStackView.addArrangedSubview(timerLabel)
        view.addSubview(scoreBoardStackView)
        
        
        submitButton.addTarget(self, action: #selector(submitPressed), for: .touchUpInside)
        
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
  
     //Start the timer
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    //Not implemented yet
    func setUPMatchMaking() {
        let size = CGSize(width: 50, height: 50)
        startAnimating(size, message: "Matchmaking", type: .ballScaleMultiple)
        SocketService.default.makeUserAvailForMatchmaking(guessMode: 0, nickname: "Doktor")
    }
    
    @objc func submitPressed() {
        //Calculate result
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        //Error causing
        score += lineUIView.getDisplayScore(guess: Double(answerTextField.text!) ?? 0.0)
        //Clear textfield and render a new result
        answerTextField.text = ""
        lineUIView.setNeedsDisplay()
        questionInHand += 1
        if (questionInHand == 10) {
            return quizOver()
        }
    }
    
    func quizOver() {
        let alert = UIAlertController(title: "Results", message: "Score: \(score)", preferredStyle: .alert)
        let action = UIAlertAction(title: "Dismiss", style: .cancel) { (action) in
            self.dismiss(animated: true) {
                self.dismiss(animated: true, completion: nil)
            }
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        //MARK: - Save highscore to core data
    
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
