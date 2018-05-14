//
//  BasicTutorialInfo.swift
//  Camera Detection Prototype
//
//  Created by Amy Wichelow on 13/03/2018.
//  Copyright © 2018 Amy Wichelow. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import Lottie

class AddTutorialStep: UIViewController {
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status and drop into background
        view.endEditing(true)
    }
    
    //text field goes away when done is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    var tutorial: Tutorial!
    
    let userTutorial = Database.database().reference().child("users").child(Auth.auth().currentUser!.uid).child("tutorials").childByAutoId()
    
    let newTutorialRef = Database.database().reference().child("tutorials").childByAutoId()
    
    var tutorialSteps = [TutorialStep]()
    
    let storageRef = Storage.storage().reference(forURL: "gs://beautyblend-26cff.appspot.com").child("CoverImage").child(Auth.auth().currentUser!.uid)

        
    @IBOutlet weak var stepLabel: UILabel!
    
    @IBOutlet weak var tutorialStepDescription: UITextView!
    
    @IBOutlet weak var stepTableView: UITableView!
    
    @IBAction func chooseImageButton(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBOutlet weak var stepImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stepLabel.text = "Step 1"
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddTutorialStep.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    
    //HOW TO CHECK A PICTURE HAS BEEN ADDED BEFORE ADDING ANOTHER STEP?
    
    @IBOutlet weak var addStepOutlet: UIButton!
    @IBAction func addStepButton(_ sender: Any) {
        
        if tutorialStepDescription.text!.isEmpty {
            let alertController = UIAlertController(title: "Error", message: "Please ensure you have entered a description for this step", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil) } else {
            
        tutorialSteps.append(TutorialStep(tutorialStepDescription: self.tutorialStepDescription.text!))
        tutorialStepDescription.text = nil
        stepLabel.text = "Step \(tutorialSteps.count + 1)"
        
        stepTableView.reloadData()
            
            print("Step \(tutorialSteps.count + 1)")
                        
        }
        
    }
    
    @IBAction func finishUploadButton(_ sender: Any) {
        
        if tutorialStepDescription.text! != "" {
            let alertController = UIAlertController(title: "Error", message: "Please ensure you have added all steps before uploading tutorial", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
        
        } else {
            
        upload { success in
            print("All steps uploaded")
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomepageViewControllerContainer")
            self.present(vc!, animated: true, completion: nil)
            }
        }
    }
    
    func upload(completion: @escaping (_ success: Bool) -> Void) {

        newTutorialRef.setValue(tutorial.toDict()) { error, ref in
            
            var count = 0

            for tutorial in self.tutorialSteps {
                ref.child("steps").childByAutoId().setValue(tutorial.toDict(), withCompletionBlock: { error, ref in
                    count += 1
                    if count == self.tutorialSteps.count {
                        completion(true)
                    }
                })
            }
        }
        
        userTutorial.updateChildValues(tutorial.toDict()) { error, ref in

            var count = 0

            for tutorial in self.tutorialSteps {
                ref.child("steps").childByAutoId().setValue(tutorial.toDict(), withCompletionBlock: { error, ref in
                    count += 1
                    if count == self.tutorialSteps.count {
                        completion(true)
                    }
                })
            }
        }
    }
    
// HOW TO UPLOAD COVER IMAGE SO IT APPEARS ON HOMEPAGE CELL
        
//        if let coverImage = tutorial.coverImage {
//            let mediaUploader = MediaUploader()
//            mediaUploader.uploadMedia(images: [coverImage]) { urls in
//
//                ref.updateChildValues(["coverImage": urls.first!], withCompletionBlock: { error, ref in
//
//                })
//            }
//        }
    
    let limitLength = 250
    func tutorialStepDescription(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = tutorialStepDescription.text else { return true }
        let newLength = text.characters.count + string.characters.count - range.length
        return newLength <= limitLength
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle:   UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            tutorialSteps.remove(at: indexPath.row)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .middle)
            tableView.endUpdates()
        }
    }
        
}

extension AddTutorialStep: UITextFieldDelegate, UITextViewDelegate {


    func textViewDidChange(_ textView: UITextView) {
        if textView.text == "" {
        
            self.addStepOutlet.isEnabled = true
            
            return
        }
        
    }

}

extension AddTutorialStep: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tutorialSteps.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        
        let step = tutorialSteps[indexPath.row]
        cell?.textLabel?.text = step.tutorialStepDescription
        
        return cell!
    }
}

extension AddTutorialStep: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        guard let image = info["UIImagePickerControllerOriginalImage"] as? UIImage else { return }
        stepImageView.image = image
        dismiss(animated: true, completion: nil)
        
    }
}



