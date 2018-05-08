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
    
    let newTutorialRef = Database.database().reference().child("tutorials").childByAutoId()
    
    var tutorialSteps = [TutorialStep]()
    
    @IBOutlet weak var stepLabel: UILabel!
    
    @IBOutlet weak var tutorialStepDescription: UITextView!
    
    @IBOutlet weak var stepTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stepLabel.text = "Step 1"
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddTutorialStep.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    
    @IBAction func addStepButton(_ sender: Any) {
        tutorialSteps.append(TutorialStep(tutorialStepDescription: self.tutorialStepDescription.text!))
        tutorialStepDescription.text = nil
        stepLabel.text = "Step \(tutorialSteps.count + 1)"
        
        stepTableView.reloadData()
        
    }
    
    @IBAction func finishUploadButton(_ sender: Any) {
        upload { success in
            print("All steps uploaded")
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomepageViewControllerContainer")
            self.present(vc!, animated: true, completion: nil)
            
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
            print("enable save button")
            return
        }
        
        print("disable save button")
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



