import Firebase

class MediaUploader {
    
    func convert(_ images: [UIImage]) -> [Data] {
        var data = [Data]()
        for image in images {
            data.append(UIImageJPEGRepresentation(image, 0.5)!)
        }
        return data
    }
    
    func uploadMedia(images: [UIImage], completion: @escaping (_ url: [String]) -> Void) {
        
        let data = convert(images)
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        var imageURLs = [String]()
        
        for imageData in data {
            let random = String.randomString(length: 32)
            let storageRef = Storage.storage().reference().child(random)
            storageRef.putData(imageData, metadata: metadata) { meta, error in
                if error != nil {
                    print("error")
                } else {
                    imageURLs.append(random)
                    if imageURLs.count == data.count {
                        completion(imageURLs)
                    }
                }
            }
            
            
        }
        
        
    }
    
}
