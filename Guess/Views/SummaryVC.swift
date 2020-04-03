//
//  SummaryViewController.swift
//  Guess
//
//  Created by Rene Dubrovski on 4/4/20.
//  Copyright © 2020 articga. All rights reserved.
//

import UIKit

class SummaryVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.layer.insertSublayer(generateBGGradient(), at: 0)
    }
    
}
