//  ImageViewController.swift
//  Beauty Blend
//  Created by Amy Wichelow on 08/11/2017.
//  Copyright © 2017 Amy Wichelow. All rights reserved.

import UIKit
import Firebase
import FirebaseAuth

class SignUpViewController: UIViewController {
    
    @IBAction func dismissSignup(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    let storage = Storage.storage().reference()
    let databaseRef = Database.database().reference()
    
    @IBAction func uploadProfileImage(_ sender: Any) {
    }
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet var confirmPasswordTextField: UITextField!
    
    var profileImageView: UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ProfileImagePlaceholderAsset")
        return imageView
    }
    
    
    
    
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
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomepageViewControllerContainer")
                        self.present(vc!, animated: true, completion: nil)
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
