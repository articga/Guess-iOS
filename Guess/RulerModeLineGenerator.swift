//
//  RulerModeLineGenerator.swift
//  Guess
//
//  Created by Rene Dubrovski on 10/31/19.
//  Copyright © 2019 articga. All rights reserved.
//

//Responsible for generating and displaying the line
import UIKit

class RulerModeLineGenerator: UIView {
    
    var startPoint: CGPoint = CGPoint(x: 0, y: 0)
    var endPoint: CGPoint = CGPoint(x: 0, y: 0)
    
    var unitStartPoint: CGPoint = CGPoint(x: 0, y: 0)
    var unitEndPoint: CGPoint = CGPoint(x: 0, y: 0)
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        drawViews()
    }
    
    
    //MARK: - User Generated
    
    func drawViews() {
        print("Method drawViews was called")
        if let context = UIGraphicsGetCurrentContext() {
            drawRandomLine(context: context)
            drawRandomUnit(context: context)
        }
    }
    
    func drawRandomLine(context: CGContext) {
            context.beginPath()
            context.setStrokeColor(UIColor.red.cgColor)
            context.setLineWidth(3)
            
            let xMax = bounds.width / 3
            let yMax = bounds.height / 3
            
            let randomX = CGFloat.random(in: 5..<xMax)
            let randomY = CGFloat.random(in: 5..<yMax)
        
            let xMaxEnd = bounds.width - 5.0
            let yMaxEnd = bounds.height - 5.0
            
            let randomXEnd = CGFloat.random(in: 5..<xMaxEnd)
            let randomYEnd = CGFloat.random(in: 5..<yMaxEnd)
            
            startPoint = CGPoint(x: randomX, y: randomY)
            endPoint = CGPoint(x: randomXEnd, y: randomYEnd)
            
            print("Generated a line with an end point: \(randomX) : \(randomY)")
            //LINE START
            context.move(to: startPoint)
            //LINE END
            context.addLine(to: endPoint)
            
            context.strokePath()
    }
    
    func drawRandomUnit(context: CGContext) {
        let unitLabel: UILabel = {
            let label = UILabel(frame: CGRect(x: bounds.width - 140, y: bounds.height / 2 + 15, width: 100, height: 30))
            //label.center = CGPoint(x: 0, y: 0)
            label.text = "1 Unit"
            label.adjustsFontSizeToFitWidth = true
            label.font = UIFont(name: "Halvetica", size: 17)
            label.textColor = .blue
            label.textAlignment = .right
            return label
        }()
        
        context.beginPath()
        context.setStrokeColor(UIColor.blue.cgColor)
        context.setLineWidth(3)
        
        //Random unit generation
        let randomYConstant = CGFloat.random(in: -100...20)
        
        unitStartPoint = CGPoint(x: bounds.width - 30, y: bounds.height / 2)
        unitEndPoint = CGPoint(x: bounds.width - 30, y: bounds.height - 30 + randomYConstant)
        
        
        context.move(to: unitStartPoint)
        context.addLine(to: unitEndPoint)
        
        context.strokePath()
        addSubview(unitLabel)
    }
    
    public func calculateLineLength(initialPoint: CGPoint, endPoint: CGPoint, unitInitialPoint: CGPoint, unitEndPoint: CGPoint) -> Double {
        //Main line
        let xRoot: CGFloat = pow((endPoint.x - initialPoint.x), 2)
        let yRoot: CGFloat = pow((endPoint.y - initialPoint.y), 2)
        let mainLineLength = (xRoot + yRoot).squareRoot()
        
        //Unit line
        let xUnitRoot: CGFloat = pow((unitEndPoint.x - unitInitialPoint.x), 2)
        let yUnitRoot: CGFloat = pow((unitEndPoint.y - unitInitialPoint.y), 2)
        let unitLineLength = (xUnitRoot + yUnitRoot).squareRoot()
        
        return Double(mainLineLength / unitLineLength).rounded(toPlaces: 2)
    }
    
    func getResults(guess: Double) -> Double {
        let lineLength = calculateLineLength(initialPoint: startPoint, endPoint: endPoint, unitInitialPoint: unitStartPoint, unitEndPoint: unitEndPoint)
        let acc = ((Double(lineLength) - guess) / Double(lineLength)) * 100
        return Double(acc).rounded(toPlaces: 2)
    }
    
    func returnCorrectAnswer() -> Double {
        return Double(calculateLineLength(initialPoint: startPoint, endPoint: endPoint, unitInitialPoint: unitStartPoint, unitEndPoint: unitEndPoint))
    }
}


