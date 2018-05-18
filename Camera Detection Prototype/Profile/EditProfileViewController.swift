import UIKit
import Firebase


class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    var databaseRef: DatabaseReference!
    var storageRef: StorageReference!
    
    @IBOutlet weak var newPassword: UITextField!
    @IBOutlet weak var newEmail: UITextField!
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
    
    
    @IBAction func deleteUserAccountButton(_ sender: Any) {
        
        // Create the alert controller
        let alertController = UIAlertController(title: "Wait", message: "Are you sure you want to delete your account?", preferredStyle: .alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: "Delete", style: UIAlertActionStyle.default) {
            UIAlertAction in
            NSLog("OK Pressed")
            let user = Auth.auth().currentUser
            
            if Error.self == nil {
                print(Error.self)
            } else {
                user?.delete(completion: { error in
                })
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController")
                self.present(vc!, animated: true, completion: nil)
                print("Account Deleted")
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }
        
        // Add the actions
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        // Present the controller
        self.present(alertController, animated: true, completion: nil)
    
    }
    
    
    @IBOutlet weak var saveButton: UIButton!
    @IBAction func saveButton(_ sender: Any) {
        
        updateUserInfo()
        
        let alert = UIAlertController(title: "Success", message: "Profile has been updated.", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
        
        self.navigationController?.popToRootViewController(animated: true)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let uid = Auth.auth().currentUser!.uid
        let userRef = Database.database().reference(withPath: "users/\(uid)")
        
        userRef.observeSingleEvent(of: .value, with: { snapshot in
            if let user = Users(snapshot: snapshot) {
                self.usernameText.text = user.username
            }
            if let user = Users(snapshot: snapshot) {
                print(user.userImageUrl as Any)
                
                _ = Storage.storage().reference(withPath: user.userImageUrl!).getData(maxSize: 2 * 1024 * 1024, completion: { data, error in
                    print(data as Any)
                    let image = UIImage(data: data!)
                    self.profileImageView.image = image
                })
            }
        })
    }
    
    
    func usernameText(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = usernameText.text else { return true }
        
        let limitLength = 15
        let newLength = text.characters.count + string.characters.count - range.length
        return newLength <= limitLength
    }
    
    
    func updateUserInfo() {
        
        let user = Auth.auth().currentUser
        let ref = Database.database().reference(withPath: "users/\(user!.uid)")
        let image = self.profileImageView.image
        let mediaUploader = MediaUploader()
        
        mediaUploader.uploadMedia(images: [image!]) { urls in
                
        ref.updateChildValues(["profileImage": urls.first!]) { error, ref in
            
            return
            
            }
        }
        
            let fieldTextLength = usernameText.text!.characters.count
            let username = Database.database().reference().child("usernames")

            if  fieldTextLength < 6 || fieldTextLength  > 18 {
                
                let alert = UIAlertController(title: "Sorry", message: "This username is not long enough", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
                
            } else {
                
                username.observeSingleEvent(of: .value) { (snapshot) in
                    if snapshot.exists(){
                        print("username already exists")
                        
                        let alert = UIAlertController(title: "Sorry", message: "This username already exists", preferredStyle: .alert)
                        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alert.addAction(action)
                        self.present(alert, animated: true, completion: nil)
                        
                    } else {
                        
                        ref.updateChildValues(["username": self.usernameText.text!]) { error, ref in
                            
                            return
                        }
                    }
                }
                
        }

        
        
        user?.updateEmail(to: self.newEmail.text!) { error in
            
            if (self.newEmail.text?.isEmpty)! {
                
            }
            
            if let firebaseError = error {
                
                print(firebaseError.localizedDescription)
                let alert = UIAlertController(title: "Error", message: firebaseError.localizedDescription, preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
                
                return
                
            } else {
                
                
                return
                
            }
        }
        
        user?.updatePassword(to: self.newPassword.text!) { error in
            
            if (self.newEmail.text?.isEmpty)! {
                
            }
            
                return
        }
    
    }
        
    func isValidPasswordString(pwdStr:String) -> Bool {
        
        let pwdRegEx = "(?:(?:(?=.*?[0-9])(?=.*?[-!@#$%&*ˆ+=_])|(?:(?=.*?[0-9])|(?=.*?[A-Z])|(?=.*?[-!@#$%&*ˆ+=_])))|(?=.*?[a-z])(?=.*?[0-9])(?=.*?[-!@#$%&*ˆ+=_]))[A-Za-z0-9-!@#$%&*ˆ+=_]{6,15}"
        let pwdTest = NSPredicate(format:"SELF MATCHES %@", pwdRegEx)
        return pwdTest.evaluate(with: pwdStr)
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
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
