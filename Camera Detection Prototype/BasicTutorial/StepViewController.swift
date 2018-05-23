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
        
        //take back to tutorial count - 1???
        
    }
    
    @IBAction func nextStepButton(_ sender: Any) {
        
        if stepLabel.text == "Step \(tutorial.steps.count + 1)" as String? {
            
            self.performSegue(withIdentifier: "shareViewController", sender: self)
            
        } else {
            
            tutorialStepDescription = nil
            stepImageView = nil
            
            stepLabel.text = "Step \(tutorial.steps.count)"
            
            tutorialStepDescription.text = tutorial.steps
            stepImageView.image = tutorial.steps
            
        }
    }
    
    @IBOutlet weak var stepImageView: UIImageView!

    @IBOutlet weak var tutorialStepDescription: UITextView!
    
    var tutorial: Tutorial!
    
    override func viewDidLoad() {
        
        stepLabel.text = "Step 1"
        print(tutorial.tutorialName)
        
        title = tutorial.tutorialName
        for set in tutorial.steps {
            print(set.tutorialStepDescription)
        }
        
        if stepLabel.text == "Step 1" {
            self.previousStepOutlet.isHidden = true } else {
            self.previousStepOutlet.isHidden = false
        }
        
        
        Storage.storage().reference(withPath: tutorial.steps[0].stepImageId!).getData(maxSize: 2 * 1024 * 1024, completion: { data, error in
            //self.tutorialStep.stepImage = UIImage(data: data!)
        })
        
        let tutorialRef = Database.database().reference().child("tutorials").child(tutorial.uuid!).child("steps")
        
        tutorialRef.observeSingleEvent(of: .value, with: { snapshot in
            
            for tutorialSteps in snapshot.children {
                if let data = tutorialSteps as? DataSnapshot {
                    if let tutorial = TutorialStep(snapshot: data) {
                        self.tutorial.steps.append(tutorial)
                        self.tutorialStepDescription.text = tutorial.tutorialStepDescription
                        self.stepImageView.image = tutorial.stepImage
                    }
                }
            }
            
            self.tutorial.steps = self.tutorial.steps.sorted(by: { $0.position < $1.position })
            
        })
    }    
}
