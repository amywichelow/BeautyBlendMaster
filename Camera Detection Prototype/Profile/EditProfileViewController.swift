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
        databaseRef = Database.database().reference()
        storageRef = Storage.storage().reference()
        
       // loadProfileData()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TutorialUploadViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    
//    Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
//
//    if error == nil {
//    print("You have successfully signed up")
//
//    let ref = Database.database().reference(withPath: "users/\(user!.uid)")
//    ref.updateChildValues(["username": self.usernameTextField.text!]) { error, ref in
//
//    if let image = self.profileImageView.image {
//    let mediaUploader = MediaUploader()
//    mediaUploader.uploadMedia(images: [image]) { urls in
//
//    ref.updateChildValues(["profileImage": urls.first!], withCompletionBlock: { error, ref in
    
    
    func updateUserInfo() {
        
        let user = Auth.auth().currentUser
        let ref = Database.database().reference(withPath: "users/\(user!.uid)")
        
        ref.updateChildValues(["username": self.usernameText.text!]) { error, ref in
        
            if (self.usernameText.text?.isEmpty)! {
                
            } else {
                
                let alert = UIAlertController(title: "Success", message: "Username has been updated.", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
                
                self.navigationController?.popToRootViewController(animated: true)

                
            }
        
        }
        
        user?.updateEmail(to: newEmail.text!) { error in
            
            if (self.newEmail.text?.isEmpty)! {
                
            } else {
                
                let alert = UIAlertController(title: "Success", message: "Email has been updated.", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
                
                self.navigationController?.popToRootViewController(animated: true)

                
            }
            
        }
        
        user?.updatePassword(to: newPassword.text!) { error in
            
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
    //what happens when the user hits cancel?
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}
