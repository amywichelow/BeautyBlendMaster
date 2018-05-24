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
    let newTutorialRef = Database.database().reference().child("tutorials").childByAutoId()
    let userTutorial = Database.database().reference().child("users").child(Auth.auth().currentUser!.uid).child("tutorials").childByAutoId()
    

    @IBOutlet weak var stepLabel: UILabel!
    
    @IBOutlet weak var tutorialStepDescription: UITextView!
    
    @IBOutlet weak var stepTableView: UITableView!
    
    @IBAction func imageButton(_ sender: Any) {
        
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
            let alertController = UIAlertController(title: "Error", message: "Image and description required in order to upload step", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
            return
        }
        
        
        let newStep = TutorialStep(tutorialStepDescription: self.tutorialStepDescription.text!, stepImage: self.stepImageOutlet.image!, position: self.tutorial.steps.count)
        tutorial.steps.append(newStep)

        
        tutorialStepDescription.text = nil
        stepImageOutlet.image = nil

        
        stepLabel.text = "Step \(tutorial.steps.count + 1)"
        
        stepTableView.reloadData()
        
        

    }
    
    @IBAction func finishUploadButton(_ sender: Any) {
        
        guard tutorial.steps.count > 0  else {
            
            let alertController = UIAlertController(title: "Error", message: "Please ensure you have added at least one step to this tutorial", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
            return
        }
        
        
        guard tutorialStepDescription.text != nil else {
            let alertController = UIAlertController(title: "Error", message: "Please ensure you have added all steps before uploading tutorial", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
            return
        
        }
        
        guard let mainImage = self.tutorial.mainImage else { return }
        
        let mediaUploader = MediaUploader()
        
        mediaUploader.uploadMedia(images: [mainImage]) { urls in
            
            if let imageid = urls.first {
                
                self.tutorial.mainImageId = imageid

                self.newTutorialRef.setValue(self.tutorial.toDict(), withCompletionBlock: { error, ref in
                    
                    self.upload(steps: self.tutorial.steps, to: ref, completion: { success in
//                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomepageViewControllerContainer")
//                        self.present(vc!, animated: true, completion: nil)
                        print("tutorial success")
                    })

                })

            }
            
        }
        
        mediaUploader.uploadMedia(images: [mainImage]) { urls in
            
            if let imageid = urls.first {
                
                self.tutorial.mainImageId = imageid
                
                self.userTutorial.setValue(self.tutorial.toDict(), withCompletionBlock: { error, ref in
                    
                    self.upload(steps: self.tutorial.steps, to: ref, completion: { success in
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomepageViewControllerContainer")
                        self.present(vc!, animated: true, completion: nil)
                        print("user success")
                    })
                    
                })
                
            }
            
        }
            
//        uploadImage { success in
//            print("images uploaded")
//
//            self.upload { success in
//                print("all steps uploaded")
//
//            }
//
//        }
        
    }
    
    func upload(steps: [TutorialStep], to ref: DatabaseReference, completion: @escaping (_ success: Bool) -> Void) {
        
        let mediaUploader = MediaUploader()
        var counter = 0
        
        for step in steps {
            
            mediaUploader.uploadMedia(images: [step.stepImage!]) { urls in
                
                step.stepImageId = urls.first!
                ref.child("steps").childByAutoId().setValue(step.toDict(), withCompletionBlock: { error, ref in
                    
                    counter += 1
                    if counter == steps.count {
                        
                        completion(true)
                    }
                })
            }
        }
    }
    
    func upload(completion: @escaping (_ success: Bool) -> Void) {
        
        newTutorialRef.updateChildValues(tutorial.toDict()) { error, ref in
            var count = 0
            for tutorial in self.tutorial.steps {
                ref.child("steps").childByAutoId().setValue(tutorial.toDict(), withCompletionBlock: { error, ref in
                    count += 1
                    if count == self.tutorial.steps.count {
                        completion(true)
                    }
                })
            }
        }

        userTutorial.updateChildValues(tutorial.toDict()) { error, ref in
            var count = 0
            for tutorial in self.tutorial.steps {
                ref.child("steps").childByAutoId().setValue(tutorial.toDict(), withCompletionBlock: { error, ref in
                    count += 1
                        if count == self.tutorial.steps.count {
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
            tutorial.steps.remove(at: indexPath.row)
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
        
        return tutorial.steps.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = stepTableView.dequeueReusableCell(withIdentifier: "Cell") as! ShowStepCell
        
        let step = tutorial.steps[indexPath.row]
        
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
