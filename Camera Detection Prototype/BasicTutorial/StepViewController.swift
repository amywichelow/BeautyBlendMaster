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
        
        currentStep -= 1
        showStep()
    }
    
    @IBOutlet weak var nextStepOutlet: UIButton!
    @IBAction func nextStepButton(_ sender: Any) {
        currentStep += 1
        showStep()
        
//        if stepLabel.text == "Step \(tutorial.steps.count + 1)" as String? {
//
//            self.performSegue(withIdentifier: "shareViewController", sender: self)
//
//        }
        //else {
//
//            stepLabel.text = "Step \(tutorial.steps.count)"
//
//            print(tutorial.steps.count)
//
//
//        }
    }
    
    func showStep() {
        
        guard currentStep < tutorial.steps.count else {
                        
            self.performSegue(withIdentifier: "shareViewController", sender: self)
            
            return
        }
        
        if stepLabel.text == "Step 1" {
            self.previousStepOutlet.isHidden = false
            
        } else {
            self.previousStepOutlet.isHidden = true
        }

        title = tutorial.tutorialName
        stepLabel.text = "Step \(currentStep + 1)"
        self.tutorialStepDescription.text = tutorial.steps[currentStep].tutorialStepDescription
        
        Storage.storage().reference(withPath: tutorial.steps[currentStep].stepImageId!).getData(maxSize: 2 * 1024 * 1024, completion: { data, error in
            
            self.stepImageView.image  = UIImage(data: data!)
            
        })
        
        let tutorialRef = Database.database().reference().child("tutorials").child(tutorial.uuid!).child("steps")
        
        tutorialRef.observeSingleEvent(of: .value, with: { snapshot in
            
            for tutorialSteps in snapshot.children {
                if let data = tutorialSteps as? DataSnapshot {
                    if let tutorial = TutorialStep(snapshot: data) {
                        self.tutorial.steps.append(tutorial)
                    //    self.tutorialStepDescription.text = tutorial.tutorialStepDescription
                      //  self.stepImageView.image = tutorial.stepImage
                    }
                }
            }
        })
    }
    
    @IBOutlet weak var stepImageView: UIImageView!

    @IBOutlet weak var tutorialStepDescription: UITextView!
    
    var tutorial: Tutorial!
    var currentStep = 0
    
    override func viewDidLoad() {
        
        showStep()

    }
}
