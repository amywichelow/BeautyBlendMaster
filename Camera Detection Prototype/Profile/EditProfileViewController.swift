import UIKit
import Firebase

class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    var databaseRef: DatabaseReference!
    var storageRef: StorageReference!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        databaseRef = Database.database().reference()
        storageRef = Storage.storage().reference()
        
        loadProfileData()
    }
    
    func loadProfileData(){
        //if the user is logged in get the profile data
        if let userID = Auth.auth().currentUser?.uid{
            databaseRef.child("profile").child(userID).observe(.value, with: { (snapshot) in
                
                //create a dictionary of users profile data
                let values = snapshot.value as? NSDictionary
                
                //if there is a url image stored in photo
                if let profileImageURL = values?["photo"] as? String{
                    //using sd_setImage load photo
                    self.profileImageView.sd_setImage(with: URL(string: profileImageURL), placeholderImage: UIImage(named: "empty-profile-1.png"))
                }
                
                self.usernameText.text = values?["username"] as? String
                
                
                
            })
            
        }//end of if
    }//end of loadProfileData
    
}
