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
        
        if stepLabel.text == "Step \(tutorialSteps.count + 1)" as String? {
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ShareViewController")
            self.present(vc!, animated: true, completion: nil)
            
        } else {
            
            stepLabel.text = "Step \(tutorialSteps.count)"
            
        }
            
    }
    
    
    @IBOutlet weak var stepImageView: UIImageView!
    
    @IBOutlet weak var tutorialStepDescription: UITextView!
    
    var tutorialStep: TutorialStep!
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
            self.previousStepOutlet.isHidden = true } else {
            self.previousStepOutlet.isHidden = false
        }
        
        
        Storage.storage().reference(withPath: tutorial.mainImageId!).getData(maxSize: 2 * 1024 * 1024, completion: { data, error in
            self.tutorial.mainImage = UIImage(data: data!)
            self.stepImageView.image = self.tutorial.mainImage
        })
        
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
