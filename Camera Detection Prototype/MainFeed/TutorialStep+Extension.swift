import Foundation
import Firebase

extension TutorialStep {
    
    func toDict() -> [String: Any] {
        
        var dict: [String: Any] =  [
            
            "tutorialStepDescription": tutorialStepDescription,
            "position": position
          
        ]
        
        if let stepImageId = stepImageId {
            dict["stepImageId"] = stepImageId
        }
        
        return dict

    }
    
}

