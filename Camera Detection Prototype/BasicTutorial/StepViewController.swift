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
    
    @IBOutlet weak var previousStepOutlet: UIButton!
    
    @IBAction func previousStepButton(_ sender: Any) {
        
        
    }
    
    @IBAction func nextStepButton(_ sender: Any) {
        
    //    stepLabel.text = "Step \(tutorialSteps.count + 1)"
    
    //if step label = tutorial step count + 1  then take user to share result screen
    
        
        
    }
    
    @IBOutlet weak var tutorialStepDescription: UITextView!
    
    
    var tutorial: Tutorial!
    var tutorialSteps = [TutorialStep]()
    
    override func viewDidLoad() {
        
        stepLabel.text = "Step 1"
        print(tutorial.tutorialName)
        
        title = tutorial.tutorialName
        for set in tutorial.steps {
            print(set.tutorialStepDescription)
        }
        
        if stepLabel.text == "Step 1" {
            
            self.previousStepOutlet.isHidden = true
            
        }
        
        else {

            self.previousStepOutlet.isHidden = false

        }
        
        let tutorialRef = Database.database().reference().child("tutorials").child(tutorial.uuid!).child("steps")
        
        tutorialRef.observeSingleEvent(of: .value, with: { snapshot in
            
            for tutorialSteps in snapshot.children {
                if let data = tutorialSteps as? DataSnapshot {
                    if let tutorial = TutorialStep(snapshot: data) {
                        self.tutorialSteps.append(tutorial)
                        self.tutorialStepDescription.text = tutorial.tutorialStepDescription
                    }
                }
            }
        })
    
    
        
    }
    
    
    
}
