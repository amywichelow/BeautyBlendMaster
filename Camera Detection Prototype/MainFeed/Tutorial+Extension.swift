import Foundation
import Firebase

extension Tutorial {
    
    func toDict() -> [String: Any] {
        return [
//            "coverImage": coverImage,
            "tutorialName": tutorialName,
            "duration": duration,
            "difficulty": difficulty,
            "user": CustomUser.shared.username!,
            "usser_uid": Auth.auth().currentUser!.uid
        ]
    }
    
}
