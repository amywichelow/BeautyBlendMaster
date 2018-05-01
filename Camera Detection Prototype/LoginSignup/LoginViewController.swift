//  ImageViewController.swift
//  Beauty Blend
//  Created by Amy Wichelow on 08/11/2017.
//  Copyright © 2017 Amy Wichelow. All rights reserved.

import UIKit
import Firebase

class LoginViewController: UIViewController {
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            if let user = user {
                
                let ref = Database.database().reference(withPath: "users/\(user.uid)")
                ref.observeSingleEvent(of: .value, with: { snapshot in
                    let snapValue = snapshot.value as! [String: Any]
                    CustomUser.shared.username = snapValue["username"] as! String
                })
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomepageViewControllerContainer")
                self.present(vc!, animated: true, completion: nil)

                
            }
        }
        
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(true)
//        if Auth.auth().currentUser != nil {
//            performSegue(withIdentifier: "HomepageViewControllerContainer", sender: self)
//        }
//    }
    
    
}



