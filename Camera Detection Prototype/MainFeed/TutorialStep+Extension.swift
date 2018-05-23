import Foundation
import Firebase

extension TutorialStep {
    
    func toDict() -> [String: Any] {
        
        let dict: [String: Any] =  [
            
            "tutorialStepDescription": tutorialStepDescription,
            "position": position,
            "stepImageId": stepImageId!
            
        ]
        
//        if let stepImageId = stepImageId {
//            dict["stepImageId"] = stepImageId
//        }
        
        return dict

    }
    
}

