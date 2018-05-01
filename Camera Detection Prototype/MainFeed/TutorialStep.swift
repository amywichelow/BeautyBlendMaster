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
    
    init?(snapshot: DataSnapshot) {
        
        if let snapshotData = snapshot.value as? [String: Any] {
            
            tutorialStepDescription = snapshotData ["tutorialStepDescription"] as! String
            
        } else {
            return nil
        }
        
    }
    

    init(tutorialStepDescription: String) {
        
        self.tutorialStepDescription = tutorialStepDescription
        
    }
    
    
}
