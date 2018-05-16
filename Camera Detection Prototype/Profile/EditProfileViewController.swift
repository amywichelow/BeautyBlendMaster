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
        
        let user = Auth.auth().currentUser
        
        let alert = UIAlertController(title: "Delete Account", message: "Are you sure you want to delete your account?", preferredStyle: .alert)
        let action = UIAlertAction(title: "Yes", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
        
        user?.delete { error in
            
            if error != nil {
                let alert = UIAlertController(title: "Error", message: "Something went wrong and your account could not be deleted", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
                
            } else {

                self.dismiss(animated: true, completion: nil)
            }
        }
        
    }
    
    
    @IBAction func saveButton(_ sender: Any) {
        
        updateUserInfo()
        
        self.navigationController?.popToRootViewController(animated: true)
        
        let alert = UIAlertController(title: "Success", message: "Profile has been updated.", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let uid = Auth.auth().currentUser!.uid
        let userRef = Database.database().reference(withPath: "users/\(uid)")
        
        userRef.observeSingleEvent(of: .value, with: { snapshot in
            if let user = Users(snapshot: snapshot) {
                print(user.userImageUrl as Any)
                
                _ = Storage.storage().reference(withPath: user.userImageUrl!).getData(maxSize: 2 * 1024 * 1024, completion: { data, error in
                    print(data as Any)
                    let image = UIImage(data: data!)
                    self.profileImageView.image = image
                })
            }
            print(snapshot)
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
                    
                    if (self.profileImageView.image == nil) {
                        
                    } else {
                    
                    let alert = UIAlertController(title: "Success", message: "Username has been updated.", preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                    
                    self.navigationController?.popToRootViewController(animated: true)
                }
            }
        }
        
        ref.updateChildValues(["username": self.usernameText.text!]) { error, ref in
        
            if (self.usernameText.text?.isEmpty)! {
                
                let alert = UIAlertController(title: "Error", message: "Please choose a username.", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
                
            } else {
                
                let alert = UIAlertController(title: "Success", message: "Username has been updated.", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
                
                self.navigationController?.popToRootViewController(animated: true)
                
            }
        }
        
        user?.updateEmail(to: self.newEmail.text!) { error in
            
            if (self.newEmail.text?.isEmpty)! {
                
            } else {
                
                let alert = UIAlertController(title: "Success", message: "Email has been updated.", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
                
                self.navigationController?.popToRootViewController(animated: true)
                
            }
        }
        
        user?.updatePassword(to: self.newPassword.text!) { error in
            
            if (self.newPassword.text?.isEmpty)! {
                
            } else {
                
                    let alert = UIAlertController(title: "Success", message: "Password has been updated.", preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
    
                self.navigationController?.popToRootViewController(animated: true)
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
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
