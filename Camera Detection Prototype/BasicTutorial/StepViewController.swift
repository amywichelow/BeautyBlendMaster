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
    
    @IBOutlet weak var tutorialStepDescription: UITextView!
    
    
    var tutorial: Tutorial!
    var tutorialSteps = [TutorialStep]()
    let tutorialRef = Database.database().reference().child("tutorials").child("steps").child("tutorialStepDescription")

    
    override func viewDidLoad() {
        
        tutorialRef.observeSingleEvent(of: .value, with: { snapshot in
            
            for tutorialSteps in snapshot.children {
                if let data = tutorialSteps as? DataSnapshot {
                    if let tutorial = Tutorial(snapshot: data) {
                        self.tutorialSteps.append(tutorialSteps as! TutorialStep)
                    }
                }
            }
        })

        
        stepLabel.text = "Step 1"
        
        print(tutorial.tutorialName)
        title = tutorial.tutorialName
        for set in tutorial.steps {
            print(set.tutorialStepDescription)
        }
    }
    
    
    
}
