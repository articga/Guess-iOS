//
//  RuleModeGenerator.swift
//  Guess
//
//  Created by Rene Dubrovski on 4/5/20.
//  Copyright © 2020 articga. All rights reserved.
//

import UIKit
import Haptica

protocol RulerModeDelegate {
    func scoreGenerated(newScoreAmount: Int)
    func indexIncremented(newIndex: Int)
    func labelShouldBeRed(isTrue: Bool)
    func timeValueChanged(newValue: Int)
    func quizEnded()
}

class RulerModeLineGenerator: UIView {
    //Line start point
    var startPoint: CGPoint = CGPoint(x: 0, y: 0)
    var endPoint: CGPoint = CGPoint(x: 0, y: 0)
    
    //Line end point
    var unitStartPoint: CGPoint = CGPoint(x: 0, y: 0)
    var unitEndPoint: CGPoint = CGPoint(x: 0, y: 0)

    var delegate: RulerModeDelegate?
    var countdownTimer: Timer!
    var timerCount = 10 {
        didSet {
            delegate?.timeValueChanged(newValue: timerCount)
        }
    }
    var currentQuestionIndex = 1 {
        didSet {
            delegate?.indexIncremented(newIndex: currentQuestionIndex)
        }
    }
    var score = 0 {
        didSet {
            delegate?.scoreGenerated(newScoreAmount: score)
        }
    }
    
    override func draw(_ rect: CGRect) {
        layer.cornerRadius = 10
        layer.masksToBounds = true
        if (currentQuestionIndex <= 10) {
            if let context = UIGraphicsGetCurrentContext() {
                drawRandomLine(context: context)
                drawRandomUnit(context: context)
            }
        } else {end()}
    }
    
    func initateView(questionAmount: Int, timePerQuestion: Int) {
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
        
    //MARK: - Line Drawing
    
    private func drawRandomLine(context: CGContext) {
            context.beginPath()
            context.setStrokeColor(UIColor.black.cgColor)
            context.setLineWidth(3)
            
            let xMax = bounds.width / 3
            let yMax = bounds.height / 3
            
            let randomX = CGFloat.random(in: 5..<xMax)
            let randomY = CGFloat.random(in: 5..<yMax)
        
            let xMaxEnd = bounds.width - 5.0
            let yMaxEnd = bounds.height - 5.0
            
            let randomXEnd = CGFloat.random(in: 5..<xMaxEnd)
            let randomYEnd = CGFloat.random(in: 20..<yMaxEnd)
            
            startPoint = CGPoint(x: randomX, y: randomY)
            endPoint = CGPoint(x: randomXEnd, y: randomYEnd)
            
            print("Generated a line with an end point: \(randomX) : \(randomY)")
            //LINE START
            context.move(to: startPoint)
            //LINE END
            context.addLine(to: endPoint)
            
            context.strokePath()
    }
    
    private func drawRandomUnit(context: CGContext) {
        let unitLabel: UILabel = {
            let label = UILabel()
            label.text = "Unit"
            label.adjustsFontSizeToFitWidth = true
            label.font = UIFont(name: "HelveticaNeue-Bold", size: 15)
            label.textColor = .black
            label.textAlignment = .center
            return label
        }()
        
        context.beginPath()
        context.setStrokeColor(UIColor.red.cgColor)
        context.setLineWidth(3)
        
        let xRoot: CGFloat = pow((endPoint.x - startPoint.x), 2)
        let yRoot: CGFloat = pow((endPoint.y - startPoint.y), 2)
        let mainLineLength = CGFloat((xRoot + yRoot).squareRoot())
        
        var randomYConstant: CGFloat = 0.0
        
        if (mainLineLength >= 20) {
            randomYConstant = CGFloat.random(in: 20...mainLineLength)
        } else {
            print("Fallback constant")
            randomYConstant = 40.0
        }
        
        unitStartPoint = CGPoint(x: bounds.width - 10, y: bounds.height - 10)
        unitEndPoint = CGPoint(x: bounds.width - 10 - abs(randomYConstant), y: bounds.height - 10)
        
        unitLabel.frame = CGRect(x: bounds.width - 40, y: bounds.height - 34, width: 30, height: 20)
        context.move(to: unitStartPoint)
        context.addLine(to: unitEndPoint)
        
        context.strokePath()
        addSubview(unitLabel)
    }
    
    //MARK: - Logic
    
    func submitAnswer(answer: String) {
        delegate?.labelShouldBeRed(isTrue: false)
        timerCount = 10
        currentQuestionIndex += 1
        //Cal score
        score += calculateScore(guess: Double(answer)!)
    }
    
    private func calculateScore(guess: Double) -> Int {
        //Calculating both line lengths
        let xRoot: CGFloat = pow((endPoint.x - startPoint.x), 2)
        let yRoot: CGFloat = pow((endPoint.y - startPoint.y), 2)
        let mainLineLength = (xRoot + yRoot).squareRoot()

        let xUnitRoot: CGFloat = pow((unitEndPoint.x - unitStartPoint.x), 2)
        let yUnitRoot: CGFloat = pow((unitEndPoint.y - unitStartPoint.y), 2)
        let unitLineLength = (xUnitRoot + yUnitRoot).squareRoot()
        
        let correctLineLength = Double(mainLineLength / unitLineLength).rounded(toPlaces: 1)
        
        //Applysupersecretformula
//        let accu = abs(((Double(correctLineLength) - Double(guess)) / Double(correctLineLength)) * 100)
//        let o = abs(1.0 - accu)
//        let score: Double = 1000 / o
        
        let accu = abs(((Double(correctLineLength) - Double(guess)) / Double(correctLineLength)))
        let o = accu + 1
        let score = 1000 / o
        
        //print("correct: \(correctLineLength) \n accu: \(accu) \n o: \(o) \n Score: \(score)")
        return Int(score.rounded(toPlaces: 1))
    }
    
    @objc private func updateTimer() {
        //Warning haptic
        if timerCount == 3 {
            Haptic.play("o-o-o-o-o-o-o-o-o-o-o-o-o-o-o", delay: 0.2)
        }
        
        if timerCount <= 5 {
            delegate?.labelShouldBeRed(isTrue: true)
        }
        
        if timerCount != 0 {
            timerCount -= 1
            
        } else {
            countdownTimer.invalidate()
            end()
        }
    }
    
    private func end() {
        countdownTimer.invalidate()
        delegate?.quizEnded()
    }
}
