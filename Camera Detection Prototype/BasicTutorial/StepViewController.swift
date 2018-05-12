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
    
    override func viewDidLoad() {
        
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

        
        stepLabel.text = "Step 1"
        
        print(tutorial.tutorialName)
        title = tutorial.tutorialName
        for set in tutorial.steps {
            print(set.tutorialStepDescription)
        }
    }
    
    
    
}
