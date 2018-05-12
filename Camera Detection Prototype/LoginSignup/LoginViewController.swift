//  ImageViewController.swift
//  Beauty Blend
//  Created by Amy Wichelow on 08/11/2017.
//  Copyright © 2017 Amy Wichelow. All rights reserved.

import UIKit
import Firebase

import NVActivityIndicatorView


class LoginViewController: UIViewController {


   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    
    //Causes the view (or one of its embedded text fields) to resign the first responder status and drop into background
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    //text field goes away when done is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func signUpButton(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController")
        self.present(vc!, animated: true, completion: nil)
        
    }
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func login(_ sender: Any) {
        
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        
        Auth.auth().signIn(withEmail: email, password: password) { user, error in
            
            if let firebaseError = error {
                print(firebaseError.localizedDescription)
                
                let alert = UIAlertController(title: "Error", message: "Incorrect Email Address or Password", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
                
                return
            }
            
            if let user = user {
                
                let ref = Database.database().reference(withPath: "users/\(user.uid)")
                ref.observeSingleEvent(of: .value, with: { snapshot in
                    
                    let snapValue = snapshot.value as! [String: Any]
                    CustomUser.shared.username = snapValue["username"] as! String
                })
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomepageViewControllerContainer")
                self.present(vc!, animated: true, completion: nil)

                
            }     else {

                
            }

        }
        
    }
    
}



