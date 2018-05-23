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
    var mainImageId: String?
    var mainImage: UIImage?
    var timestamp: Int!
    
    var steps = [TutorialStep]()
    
    init?(snapshot: DataSnapshot) {
        
        if let snapshotData = snapshot.value as? [String: Any] {
            uuid = snapshot.key
            user = snapshotData ["user"] as! String?
            tutorialName = snapshotData ["tutorialName"] as! String
            difficulty = snapshotData ["difficulty"] as! Int
            duration = snapshotData ["duration"] as! Int
            mainImageId = snapshotData ["mainImageId"] as? String
            timestamp = snapshotData ["timestamp"] as! Int

            let stepsSnapshot = snapshot.childSnapshot(forPath: "steps")
            
            for step in stepsSnapshot.children.allObjects {
                if let step = TutorialStep(snapshot: step as! DataSnapshot) {
                    steps.append(step)
                }
            }
            
            steps = steps.sorted(by: { $0.position < $1.position })
            
        } else {
            return nil
        }
    }
    
    init(mainImage: UIImage, tutorialName: String, duration: Int, difficulty: Int) {
        self.tutorialName = tutorialName
        self.duration = duration
        self.difficulty = difficulty
        self.mainImage = mainImage
    }
}
