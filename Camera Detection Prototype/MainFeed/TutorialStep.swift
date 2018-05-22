//
//  TutorialStep.swift
//  Camera Detection Prototype
//
//  Created by Amy Wichelow on 20/03/2018.
//  Copyright © 2018 Amy Wichelow. All rights reserved.
//

import UIKit
import Firebase

class TutorialStep {
    
    let tutorialStepDescription: String
    var stepImage: UIImage?
    var stepImageId: String?
    var position: Int!
    
    init?(snapshot: DataSnapshot) {
        
        if let snapshotData = snapshot.value as? [String: Any] {
            
            tutorialStepDescription = snapshotData ["tutorialStepDescription"] as! String
            stepImageId = snapshotData ["stepImageId"] as? String
            position = snapshotData ["position"] as! Int

            
        } else {
            return nil
        }
    }
    
    
    init(tutorialStepDescription: String, stepImage: UIImage, position: Int) {
        
        self.tutorialStepDescription = tutorialStepDescription
        self.stepImage = stepImage
        self.position = position

        
    }
    
    
}
