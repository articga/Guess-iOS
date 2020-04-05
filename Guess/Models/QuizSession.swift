//
//  QuizSession.swift
//  Guess
//
//  Created by Rene Dubrovski on 2/29/20.
//  Copyright © 2020 articga. All rights reserved.
//
// Define modes

import UIKit.UIColor

class QuizSession {
    enum QuizMode {
        case unspecified
        case ruler
        case country
        case topic_facts
        case ruler_online
    }
    
    enum FetchType {
        case online
        case offline
    }
    
    //Old for tableview
    func fetchModes(type: FetchType) -> Array<Quiz> {
        if (type == FetchType.offline){
            return [Quiz(mode: .ruler, title: "Ruler", description: "How many red lines can you fit?", questionAmount: 10, imageTitle: "ruler", boxColor: UIColor(red: 0.80, green: 0.72, blue: 0.68, alpha: 1.00))]
        } else if (type == FetchType.online) {
            return [Quiz]()
        } else {
            return [Quiz]()
        }
    }
    
    //For new
    func fetchForCollectionView(type: FetchType) -> Array<Topic> {
        if (type == FetchType.offline) {
            let featuredTopic = Topic()
            featuredTopic.title = "Featured Modes"
            
            let all = Topic()
            all.title = "All"

            all.quizzes = [Quiz(mode: .ruler, title: "Ruler", description: "", questionAmount: 10, imageTitle: "ruler", boxColor: UIColor(red: 0.80, green: 0.72, blue: 0.68, alpha: 1.00)), Quiz(mode: .country, title: "World", description: "", questionAmount: 10, imageTitle: "world", boxColor: UIColor(red: 1.00, green: 0.69, blue: 0.17, alpha: 1.00))]
            featuredTopic.quizzes = [Quiz(mode: .ruler, title: "Ruler", description: "", questionAmount: 10, imageTitle: "ruler", boxColor: UIColor(red: 0.80, green: 0.72, blue: 0.68, alpha: 1.00))]
            
            return [featuredTopic, all]
        } else {
            return []
        }
    }
    
    
    
}
