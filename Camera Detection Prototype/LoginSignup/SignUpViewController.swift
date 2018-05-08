//  ImageViewController.swift
//  Beauty Blend
//  Created by Amy Wichelow on 08/11/2017.
//  Copyright © 2017 Amy Wichelow. All rights reserved.

import UIKit
import Firebase
import FirebaseAuth

class SignUpViewController: UIViewController {
        
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status and drop into background
        view.endEditing(true)
    }
    
    //text field goes away when done is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func viewDidLoad() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func isValidPasswordString(pwdStr:String) -> Bool {
        
        let pwdRegEx = "(?:(?:(?=.*?[0-9])(?=.*?[-!@#$%&*ˆ+=_])|(?:(?=.*?[0-9])|(?=.*?[A-Z])|(?=.*?[-!@#$%&*ˆ+=_])))|(?=.*?[a-z])(?=.*?[0-9])(?=.*?[-!@#$%&*ˆ+=_]))[A-Za-z0-9-!@#$%&*ˆ+=_]{6,15}"
        let pwdTest = NSPredicate(format:"SELF MATCHES %@", pwdRegEx)
        return pwdTest.evaluate(with: pwdStr)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func dismissSignup(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    var selectedImage: UIImage?
    
    @IBAction func uploadProfileImage(_ sender: Any) {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
        
        
    }
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet var confirmPasswordTextField: UITextField!
    
    
    
    @IBAction func signUpButton(_ sender: Any) {
        
        guard passwordTextField.text! == confirmPasswordTextField.text! else {
            print("Passwords dont match")
            
            return
        }
        
        if emailTextField.text == nil {
            let alertController = UIAlertController(title: "Error", message: "Please enter your email and password", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
        } else {
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                
                if error == nil {
                    print("You have successfully signed up")
                    
                    let ref = Database.database().reference(withPath: "users/\(user!.uid)")
                    ref.updateChildValues(["username": self.usernameTextField.text!]) { error, ref in

                        if let image = self.profileImageView.image {
                            let mediaUploader = MediaUploader()
                            mediaUploader.uploadMedia(images: [image]) { urls in
                                
                                ref.updateChildValues(["profileImage": urls.first!], withCompletionBlock: { error, ref in
                                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomepageViewControllerContainer")
                                    self.present(vc!, animated: true, completion: nil)

                                })
                            }
                        }
                    }
                    
                
                } else {
                    
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                
                }
            }
        }
        

    }
    
    @IBAction func confirm(_ sender: Any) {
        if confirmPasswordTextField.text == passwordTextField.text {
            confirmPasswordTextField.textColor = .green
        } else {
            confirmPasswordTextField.textColor = .red
        }
    }
}

extension SignUpViewController:UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
}

extension SignUpViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {

        guard let image = info["UIImagePickerControllerOriginalImage"] as? UIImage else { return }
        profileImageView.image = image
        dismiss(animated: true, completion: nil)
        
    }
}
