//
//  QuizSession.swift
//  Guess
//
//  Created by Rene Dubrovski on 2/29/20.
//  Copyright © 2020 articga. All rights reserved.
//
// Define modes

import Foundation

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
    
    func fetchModes(type: FetchType) -> Array<Quiz> {
        if (type == FetchType.offline){
            return [Quiz(mode: .ruler, title: "Ruler", description: "How many red lines can you fit?", questionAmount: 10)]
        } else if (type == FetchType.online) {
            return [Quiz]()
        } else {
            return [Quiz]()
        }
    }
    
    
    
}
