import Foundation
import Firebase

extension Tutorial {
    
    func toDict() -> [String: Any] {
        
        var dict: [String: Any] = [
            "tutorialName": tutorialName,
            "duration": duration,
            "difficulty": difficulty,
            "user": CustomUser.shared.username!,
            "usser_uid": Auth.auth().currentUser!.uid
        ]
        
        if let mainImageId = mainImageId {
            dict["mainImageId"] = mainImageId
        }
        
        return dict
    }
    
}
