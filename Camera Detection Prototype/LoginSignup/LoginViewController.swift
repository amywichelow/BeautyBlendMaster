//  ImageViewController.swift
//  Beauty Blend
//  Created by Amy Wichelow on 08/11/2017.
//  Copyright © 2017 Amy Wichelow. All rights reserved.

import UIKit
import Firebase
import Lottie

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
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
    
    //FORGOT PASSWORD
    @IBAction func forgotPasswordButton(_ sender: UIButton) {
        
        
        sender.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        
        UIView.animate(withDuration: 1.5,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.25),
                       initialSpringVelocity: CGFloat(8.0),
                       options: UIViewAnimationOptions.allowUserInteraction,
                       animations: {
                        sender.transform = CGAffineTransform.identity
        },
                       completion: { Void in()  }
        )
        
        let email = self.emailTextField.text
        Auth.auth().sendPasswordReset(withEmail: email!) { error in
            if let firebaseError = error {
                
                self.errorValidation.textColor = self.passwordRed
                self.errorValidation.text = "This email address does not exist"
                
                let animation = CABasicAnimation(keyPath: "position")
                animation.duration = 0.07
                animation.repeatCount = 4
                animation.autoreverses = true
                animation.fromValue = NSValue(cgPoint: CGPoint(x: self.errorValidation.center.x - 10, y: self.errorValidation.center.y))
                animation.toValue = NSValue(cgPoint: CGPoint(x: self.errorValidation.center.x + 10, y: self.errorValidation.center.y))
                
                self.errorValidation.layer.add(animation, forKey: "position")
                
                print(firebaseError.localizedDescription)
                
            } else {
                print("Reset password email sent")
                
                self.errorValidation.textColor = self.passwordGreen
                self.errorValidation.text = "A reset password link has been sent to your email"
            
            }
        }
    }
    
    @IBOutlet weak var errorValidation: UILabel!
    
    let passwordGreen = UIColor(hexString: "#4CD36F")
    let passwordRed = UIColor(hexString: "#D5504B")
    
    @IBAction func login(_ sender: UIButton) {
        
        sender.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        
        UIView.animate(withDuration: 1.5,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.25),
                       initialSpringVelocity: CGFloat(8.0),
                       options: UIViewAnimationOptions.allowUserInteraction,
                       animations: {
                        sender.transform = CGAffineTransform.identity
        },
                       completion: { Void in()  }
        )
        
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        
        Auth.auth().signIn(withEmail: email, password: password) { user, error in
            
            if let firebaseError = error {
                print(firebaseError.localizedDescription)
                
                self.errorValidation.textColor = self.passwordRed
                self.errorValidation.text = "Incorrect email address or password"
                
                let animation = CABasicAnimation(keyPath: "position")
                animation.duration = 0.07
                animation.repeatCount = 4
                animation.autoreverses = true
                animation.fromValue = NSValue(cgPoint: CGPoint(x: self.errorValidation.center.x - 10, y: self.errorValidation.center.y))
                animation.toValue = NSValue(cgPoint: CGPoint(x: self.errorValidation.center.x + 10, y: self.errorValidation.center.y))
                
                self.errorValidation.layer.add(animation, forKey: "position")
                
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
                
                }  else {
            }
        }
    }
}

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}


