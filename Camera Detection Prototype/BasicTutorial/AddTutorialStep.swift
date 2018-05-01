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

    var tutorial: Tutorial!
    
    let newTutorialRef = Database.database().reference().child("tutorials").childByAutoId()
    
    var tutorialSteps = [TutorialStep]()
    
    @IBOutlet weak var stepLabel: UILabel!
    
    @IBOutlet weak var tutorialStepDescription: UITextView!
    
    @IBOutlet weak var stepTableView: UITableView!
    
    //   var textView: UITextView?
    
    
   // let test = Texter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stepLabel.text = "Step 1"
        
       // test.viewController = self
        
    }
    
    @IBAction func addStepButton(_ sender: Any) {
        tutorialSteps.append(TutorialStep(tutorialStepDescription: self.tutorialStepDescription.text!))
        tutorialStepDescription.text = nil
        stepLabel.text = "Step \(tutorialSteps.count + 1)"
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



