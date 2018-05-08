//
//  TutorialClass.swift
//  Camera Detection Prototype
//
//  Created by Amy Wichelow on 13/03/2018.
//  Copyright © 2018 Amy Wichelow. All rights reserved.
//

import UIKit
import Firebase

class Tutorial {
    
    var uuid: String?
    var user: String?
    let tutorialName: String
    let difficulty: Int
    let duration: Int
    
    let steps = [TutorialStep]()
    
    init?(snapshot: DataSnapshot) {
        
        if let snapshotData = snapshot.value as? [String: Any] {
            uuid = snapshot.key
            user = snapshotData ["user"] as! String?
            tutorialName = snapshotData ["tutorialName"] as! String
            difficulty = snapshotData ["difficulty"] as! Int
            duration = snapshotData ["duration"] as! Int
            
            print(snapshot.childSnapshot(forPath: "steps"))
            
        } else {
            return nil
        }
        
    }
    
    init(tutorialName: String, duration: Int, difficulty: Int) {
        self.tutorialName = tutorialName
        self.duration = duration
        self.difficulty = difficulty
        
        
    }
    
}
