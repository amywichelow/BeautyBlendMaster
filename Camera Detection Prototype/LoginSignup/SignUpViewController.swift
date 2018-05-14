//  ImageViewController.swift
//  Beauty Blend
//  Created by Amy Wichelow on 08/11/2017.
//  Copyright © 2017 Amy Wichelow. All rights reserved.

import UIKit
import Firebase
import FirebaseAuth

class SignUpViewController: UIViewController {
    
    override func viewDidLoad() {

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
        
    @IBAction func uploadProfileImage(_ sender: Any) {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
        
        
    }
    
    @IBOutlet weak var errorValidation: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet var confirmPasswordTextField: UITextField!
    
    let passwordGreen = UIColor(hexString: "#4CD36F")
    let passwordRed = UIColor(hexString: "#D5504B")
    
    @IBAction func signUpButton(_ sender: UIButton) {
        
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
        
        guard passwordTextField.text! == confirmPasswordTextField.text! else {
            print("Passwords dont match")
            
            self.errorValidation.textColor = passwordRed
            self.errorValidation.text = "Passwords dont match"
            
            let animation = CABasicAnimation(keyPath: "position")
            animation.duration = 0.07
            animation.repeatCount = 4
            animation.autoreverses = true
            animation.fromValue = NSValue(cgPoint: CGPoint(x: self.errorValidation.center.x - 10, y: self.errorValidation.center.y))
            animation.toValue = NSValue(cgPoint: CGPoint(x: self.errorValidation.center.x + 10, y: self.errorValidation.center.y))
            self.errorValidation.layer.add(animation, forKey: "position")
            
            return
        }
        
        if emailTextField.text == nil {
            
            self.errorValidation.textColor = passwordRed
            self.errorValidation.text = "Please enter an email address"
            
            let animation = CABasicAnimation(keyPath: "position")
            animation.duration = 0.07
            animation.repeatCount = 4
            animation.autoreverses = true
            animation.fromValue = NSValue(cgPoint: CGPoint(x: self.errorValidation.center.x - 10, y: self.errorValidation.center.y))
            animation.toValue = NSValue(cgPoint: CGPoint(x: self.errorValidation.center.x + 10, y: self.errorValidation.center.y))
            self.errorValidation.layer.add(animation, forKey: "position")
            
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
                    
                    self.errorValidation.textColor = self.passwordRed
                    self.errorValidation.text = "Please check all fields have been completed"
                    
                    let animation = CABasicAnimation(keyPath: "position")
                    animation.duration = 0.07
                    animation.repeatCount = 4
                    animation.autoreverses = true
                    animation.fromValue = NSValue(cgPoint: CGPoint(x: self.errorValidation.center.x - 10, y: self.errorValidation.center.y))
                    animation.toValue = NSValue(cgPoint: CGPoint(x: self.errorValidation.center.x + 10, y: self.errorValidation.center.y))
                    self.errorValidation.layer.add(animation, forKey: "position")
            }
        }
    }
}
    


    
    @IBAction func confirm(_ sender: Any) {
        if confirmPasswordTextField.text == passwordTextField.text {
            confirmPasswordTextField.textColor = passwordGreen
        } else {
            confirmPasswordTextField.textColor = passwordRed
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
