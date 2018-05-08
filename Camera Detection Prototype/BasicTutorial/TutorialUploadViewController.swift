import UIKit
import FirebaseStorage
import Firebase

class TutorialUploadViewController: UIViewController, UITextFieldDelegate {
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status and drop into background
        view.endEditing(true)
    }
    
    //text field goes away when done is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func durationSliderAction(_ sender: Any) {
        

        let currentValue = Int(durationSlider.value)
        durationValue.text = "\(currentValue)"
        
    }
    
    @IBOutlet weak var durationSlider: UISlider!
    @IBOutlet weak var durationValue: UILabel!
    
    @IBAction func difficultySliderAction(_ sender: Any) {
        
        let currentValue = Int(difficultySlider.value)
        difficultyValue.text = "\(currentValue)"
        
    }
    @IBOutlet weak var difficultySlider: UISlider!
    @IBOutlet weak var difficultyValue: UILabel!
    
    
    let storage = Storage.storage()
    
    let ref = Database.database().reference().child("tutorials").childByAutoId()
    
    var tutorial: Tutorial!
    
    @IBOutlet weak var tutorialNameTextField: UITextField!
    

    @IBOutlet weak var mainTutorialImage: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TutorialUploadViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomepageViewControllerContainer")
        self.present(vc!, animated: true, completion: nil)
        
    }
    
    
    @IBAction func nextStepButton(_ sender: Any) {
        
        tutorial = Tutorial(tutorialName: self.tutorialNameTextField.text!, duration: Int(self.durationValue.text!)!, difficulty: Int(self.difficultyValue.text!)!)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! AddTutorialStep
        vc.tutorial = tutorial
    }
  
    
}

