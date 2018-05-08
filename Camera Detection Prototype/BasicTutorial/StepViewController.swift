//
//  StepViewController.swift
//  Camera Detection Prototype
//
//  Created by Amy Wichelow on 19/03/2018.
//  Copyright © 2018 Amy Wichelow. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseStorage

class StepViewContoller: UIViewController {
    
    @IBOutlet weak var stepLabel: UILabel!
    
    @IBAction func nextStepButton(_ sender: Any) {
        stepLabel.text = "Step \(tutorialSteps.count + 1)"
    }
    
    var tutorial: Tutorial!
    var tutorialSteps = [TutorialStep]()
    
    override func viewDidLoad() {
        
        stepLabel.text = "Step 1"
        
        print(tutorial.tutorialName)
        title = tutorial.tutorialName
        for set in tutorial.steps {
            print(set.tutorialStepDescription)
        }
    }
    
}
