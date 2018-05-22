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
    
    var tutorial: Tutorial!
    var tutorialStep: TutorialStep!
    let newTutorialRef = Database.database().reference().child("tutorials").childByAutoId()
    let userTutorial = Database.database().reference().child("users").child(Auth.auth().currentUser!.uid).child("tutorials").childByAutoId()
    var tutorialSteps = [TutorialStep]()
    

    @IBOutlet weak var stepLabel: UILabel!
    
    @IBOutlet weak var tutorialStepDescription: UITextView!
    
    @IBOutlet weak var stepTableView: UITableView!
    
    @IBAction func chooseImageButton(_ sender: Any) {
        
        let imagePickerController = UIImagePickerController()
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        imagePickerController.delegate = self
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: {action in
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            }))
        }
        alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { action in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBOutlet weak var stepImageOutlet: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        stepLabel.text = "Step 1"
    }
    
    
    @IBOutlet weak var addStepOutlet: UIButton!
    @IBAction func addStepButton(_ sender: Any) {
        
        guard let tutorialDescription = tutorialStepDescription.text, !tutorialDescription.isEmpty, let _ = stepImageOutlet.image, !(stepImageOutlet == nil)  else {
            let alertController = UIAlertController(title: "Error", message: "Please ensure you have entered a description for this step", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
            return
        }
        
        tutorialSteps.append(TutorialStep(tutorialStepDescription: self.tutorialStepDescription.text!, stepImage: self.stepImageOutlet.image!, position: self.tutorialSteps.count))
        tutorialStep = TutorialStep(tutorialStepDescription: self.tutorialStepDescription.text!, stepImage: self.stepImageOutlet.image!, position: self.tutorialSteps.count)
        
        tutorialStepDescription.text = nil
        stepImageOutlet.image = nil
        
        stepLabel.text = "Step \(tutorialSteps.count + 1)"
        
        stepTableView.reloadData()
        
        print("Step \(tutorialSteps.count)")

    }
    
    @IBAction func finishUploadButton(_ sender: Any) {
        
        if tutorialSteps.count == 0 {
            
            let alertController = UIAlertController(title: "Error", message: "Please ensure you have added at least one step to this tutorial", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
        }
        
        if tutorialStepDescription.text! != "" {
            let alertController = UIAlertController(title: "Error", message: "Please ensure you have added all steps before uploading tutorial", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
            return
        
        } else {
            
            uploadImage { success in
                print("images uploaded")
            
                self.upload { success in
                    print("all steps uploaded")

                }
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomepageViewControllerContainer")
                self.present(vc!, animated: true, completion: nil)
            }
        }
}
    
    func uploadImage(completion: @escaping (_ success: Bool) -> Void) {
        
        guard let stepImage = self.tutorialStep.stepImage else { return }
        guard let image = self.tutorial.mainImage else { return }


        let mediaUploader = MediaUploader()

        mediaUploader.uploadMedia(images: [image, stepImage]) { urls in

            if let imageid = urls.first {

                self.tutorial.mainImageId = imageid

                self.newTutorialRef.setValue(self.tutorial.toDict(), withCompletionBlock: { error, ref in })
                self.userTutorial.setValue(self.tutorial.toDict(), withCompletionBlock: { error, ref in })
                
                completion(true)
                
            }
            
            if let imageid = urls.first {
                
                self.tutorialStep.stepImageId = imageid
                
                self.newTutorialRef.child("steps").childByAutoId().setValue(self.tutorialStep.toDict(), withCompletionBlock: { error, ref in })
                self.userTutorial.child("steps").childByAutoId().setValue(self.tutorialStep.toDict(), withCompletionBlock: { error, ref in })
                
                completion(true)
                
                print("tutorial imageId\(self.tutorialStep.stepImageId)")
                
            }

        }

    }
    
    func upload(completion: @escaping (_ success: Bool) -> Void) {
        
        newTutorialRef.updateChildValues(tutorial.toDict()) { error, ref in
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 88
        
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
        let cell = stepTableView.dequeueReusableCell(withIdentifier: "Cell") as! ShowStepCell
        
        let step = tutorialSteps[indexPath.row]
        
        cell.textDescriptionView.text = step.tutorialStepDescription
        cell.stepImageView.image = step.stepImage

//        cell?.textLabel?.text = step.tutorialStepDescription
        
        return cell
    }
}

extension AddTutorialStep: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        guard let image = info["UIImagePickerControllerOriginalImage"] as? UIImage else { return }
        stepImageOutlet.image = image
        dismiss(animated: true, completion: nil)
    }
}
