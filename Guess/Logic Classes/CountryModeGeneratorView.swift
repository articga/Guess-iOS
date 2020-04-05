//
//  CountryModeGeneratorView.swift
//  Guess
//
//  Created by Rene Dubrovski on 4/4/20.
//  Copyright © 2020 articga. All rights reserved.
//

import UIKit
import Mapbox
import Haptica

protocol CountryModeDelegate {
    func selectedCountry(country: CountryModeGenerator.Country)
    func options(options: [Int])
    func scoreGenerated(newScoreAmount: Int)
    func indexIncremented(newIndex: Int)
    func timeValueChanged(newValue: Int)
    func labelShouldBeRed(isTrue: Bool)
    func quizEnded()
}

class CountryModeGenerator: UIView {
    
    var countries = [Country]()
    var selectedCountry = Country()
    var options = [Int]()
    var delegate: CountryModeDelegate?
    var score = 0 {
        didSet {
            delegate?.scoreGenerated(newScoreAmount: score)
        }
    }
    var questionsAmount = 0
    var currentQuestionIndex = 1
    var countdownTimer: Timer!
    var timePerQuestionConstant = 20
    var timePerQuestion = 20 {
        didSet {
            delegate?.timeValueChanged(newValue: timePerQuestion)
        }
    }
    
    struct Country: Decodable {
        var name: String?
        var lat: Double?
        var lng: Double?
        var population: Int?
        var area: Double?
        var flagURL: String?
    }
    
    
    /// Data for end users
    struct UIData {
        var score: Int
        var questionAtHand: Int
        var options: [Int]
    }
    
    override func draw(_ rect: CGRect) {
        layer.cornerRadius = 10
        layer.masksToBounds = true
    }
    
    
    /// Run this function first
    func initiateView(questionAmount: Int) {
        questionsAmount = questionAmount
        initialUI()
        //Start the timer
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    let map: MGLMapView = {
        let map = MGLMapView()
        map.styleURL = URL(string: "mapbox://styles/arcticapps/ck8lpzbxw0wjc1ilb71c1y4zg")
        map.scaleBar.isHidden = false
        map.automaticallyAdjustsContentInset = true
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
    
    private func initialUI() {
        addSubview(map)
        
        map.topAnchor.constraint(equalTo: topAnchor, constant: 0.0).isActive = true
        map.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0.0).isActive = true
        map.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0.0).isActive = true
        map.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0.0).isActive = true
        
        parseData { (didComplete, data) in
            if (didComplete) {
                self.countries = data
                reDraw()
            }
        }
    }

    /// Generate new country and answers
    private func reDraw() {
        let randomCountryID = Int.random(in: 0...countries.count - 1)
        selectedCountry = countries[randomCountryID]
        delegate?.selectedCountry(country: selectedCountry)
        generateOptions()
        if let lat = selectedCountry.lat, let lng = selectedCountry.lng {
            map.setCenter(CLLocationCoordinate2D(latitude: lat, longitude: lng), zoomLevel: 5.0, animated: true)
        }
        
    }
    
    /// Choose from 3 options, causes a correct answer to be calculated
    /// - Parameter optionID: 0,1,2 chosen answer
    func chooseOption(optionID: Int) {
        delegate?.labelShouldBeRed(isTrue: false)
        timePerQuestion = timePerQuestionConstant
        if (optionID > 2) {
            print("option Index out of range")
        } else {
            if (options[optionID] == Int(selectedCountry.area!)) {
                //let scoreToAdd = ((1.0 - ((10.0 - timePerQuestion) / timePerQuestion / 2.0)) * 100.0)
                score += 100                
            }
            
            if (currentQuestionIndex >= questionsAmount) {
                return end()
            }
            
            currentQuestionIndex += 1
            delegate?.indexIncremented(newIndex: currentQuestionIndex)
            reDraw()
        }
    }
    
    
    /// Generate 3 answer options
    private func generateOptions() {
        let area = Int(selectedCountry.area ?? 0)
        let a1 = Int(abs(area - 3000))
        let a2 = Int(abs(area + 3000))
        let ranOption1 = Int.random(in: a1...a2)
        let ranOption2 = Int.random(in: a1...a2)
        let notShuffeledArray = [area, ranOption1, ranOption2]
        options = notShuffeledArray.shuffled()
        delegate?.options(options: options)
    }
    
    @objc private func updateTimer() {
        //Warning haptic
        if timePerQuestion == 3 {
            Haptic.play("o-o-o-o-o-o-o-o-o-o-o-o-o-o-o", delay: 0.2)
        }
        
        if timePerQuestion <= 5 {
            delegate?.labelShouldBeRed(isTrue: true)
        }
        
        if timePerQuestion != 0 {
            timePerQuestion -= 1
            
        } else {
            countdownTimer.invalidate()
            end()
        }
    }
    
    
    /// End Session
    private func end() {
        countdownTimer.invalidate()
        delegate?.quizEnded()
    }
    
    
    //MARK: - Parse JSON File
    private func parseData(completion: (Bool, Array<Country>) -> ()) {
        if let path = Bundle.main.path(forResource: "countrydata", ofType: "json") {
            do {
                print("PARSING")
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonDecoder = JSONDecoder()
                let ret_D = try jsonDecoder.decode(Array<Country>.self, from: data)
                completion(true, ret_D)
              } catch let err {
                print(err)
                completion(false, [])
            }
        } else {
            print("ERROR: Path for countries not found")
            completion(false, [])
        }
    }
    
}
