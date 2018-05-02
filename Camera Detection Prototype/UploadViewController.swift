import UIKit
import Firebase

class UploadViewController: UIViewController {
    
    let storage = Storage.storage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let image = UIImage(named: "KendallTrial")!
        
        uploadMedia(image: image) { url in
            guard let url = url else { return }
            print(url)
            //do database stuff...
        }
    }
    
    func uploadMedia(image: UIImage, completion: @escaping (_ url: String?) -> Void) {
        let storageRef = Storage.storage().reference().child(String.randomString(length: 32))
        let data = UIImageJPEGRepresentation(image, 0.5)!
    
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        storageRef.putData(data, metadata: metadata) { meta, error in
         
                if error != nil {
                    print("error")
                    completion(nil)
                } else {
                    completion(meta?.downloadURL()?.absoluteString)
            }
            
        }
        
    }

}

extension String {
    
    static func randomString(length: Int) -> String {
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        return randomString + ".jpg"
    }
}


