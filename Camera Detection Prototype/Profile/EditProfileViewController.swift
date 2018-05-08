import UIKit
import Firebase
import SDWebImage


class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status and drop into background
        view.endEditing(true)
    }
    
    //text field goes away when done is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    var databaseRef: DatabaseReference!
    var storageRef: StorageReference!
    
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBAction func editProfileImage(_ sender: Any) {
        //create instance of Image picker controller
        let picker = UIImagePickerController()
        //set delegate
        picker.delegate = self
        //set details
        //is the picture going to be editable(zoom)?
        picker.allowsEditing = false
        //what is the source type
        picker.sourceType = .photoLibrary
        //set the media type
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        //show photoLibrary
        present(picker, animated: true, completion: nil)
    }
    
    @IBAction func saveButton(_ sender: Any) {
        updateUsersProfile()
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController")
        self.present(vc!, animated: true, completion: nil)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        databaseRef = Database.database().reference()
        storageRef = Storage.storage().reference()
        
        loadProfileData()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TutorialUploadViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    
    func updateUsersProfile(){
        //check to see if the user is logged in
        if let userID = Auth.auth().currentUser?.uid{
            //create an access point for the Firebase storage
            let storageItem = storageRef.child(userID)
            //get the image uploaded from photo library
            guard let image = profileImageView.image else {return}
            if let newImage = UIImagePNGRepresentation(image){
                //upload to firebase storage
                storageItem.putData(newImage, metadata: nil, completion: { (metadata, error) in
                    if error != nil{
                        print(error!)
                        return
                    }
                    storageItem.downloadURL(completion: { (url, error) in
                        if error != nil{
                            print(error!)
                            return
                        }
                        if let profilePhotoURL = url?.absoluteString{
                            guard let newUserName  = self.usernameText.text else {return}

                            let newValuesForProfile =
                                ["photo": profilePhotoURL,
                                 "username": newUserName]

                            //update the firebase database for that user
                                    self.databaseRef.child("profile").child(userID).updateChildValues(newValuesForProfile, withCompletionBlock: { (error, ref) in
                                if error != nil{
                                    print(error!)
                                    return
                                }
                                print("Profile Successfully Update")
                                        
                              
                            })
                            
                        }
                    })
                })
                
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        //create holder variable for chosen image
        var chosenImage = UIImage()
        //save image into variable
        print(info)
        chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        //update image view
        profileImageView.image = chosenImage
        //dismiss
        dismiss(animated: true, completion: nil)
    }
    //what happens when the user hits cancel?
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    
    func loadProfileData(){
        //if the user is logged in get the profile data
        if let userID = Auth.auth().currentUser?.uid{
            databaseRef.child("users").child(userID).observe(.value, with: { (snapshot) in
                
                //create a dictionary of users profile data
                let values = snapshot.value as? NSDictionary
                
                //if there is a url image stored in photo
                if let profileImageURL = values?["photo"] as? String{
                    //using sd_setImage load photo
                    self.profileImageView.sd_setImage(with: URL(string: profileImageURL), placeholderImage: UIImage(named: "KendallTrial"))
                }
                
                self.usernameText.text = values?["username"] as? String
                
                
                
            })
            
        }//end of if
    }//end of loadProfileData
    
}
