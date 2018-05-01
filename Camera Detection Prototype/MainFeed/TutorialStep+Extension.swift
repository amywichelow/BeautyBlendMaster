import Foundation
import Firebase

extension TutorialStep {
    
    func toDict() -> [String: Any] {
        return [
            
            "tutorialStepDescription": tutorialStepDescription,
          
        ]
    }
    
}

