import UIKit
import FirebaseStorage
import Firebase
import Lottie

class TutorialUploadViewController: UIViewController, UITextFieldDelegate {

    @IBAction func durationSliderAction(_ sender: UISlider!) {

        self.durationSlider.setValue((round(sender.value / 5) * 5), animated: false)

        durationValue.text = ("\(sender.value)")

        let currentValue = Int(durationSlider.value)
        durationValue.text = "\(currentValue)"

    }

    @IBAction func chooseImageButton(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
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

    @IBOutlet weak var mainImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        durationSlider.addTarget(self, action:  #selector(durationSliderAction),for: .valueChanged)
    }


    @IBAction func cancelButton(_ sender: Any) {

        dismiss(animated: true, completion: nil)

    }

    //HOW DO I GET IT TO CHECK ALL FIELDS AT THE SAME TIME?

    @IBAction func nextStepButton(_ sender: Any) {

        guard let tutorialName = tutorialNameTextField.text, !tutorialName.isEmpty  else {
            let alertController = UIAlertController(title: "Error", message: "Please ensure all fields are complete", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
            return
        }

        tutorial = Tutorial(mainImage: self.mainImageView.image!, tutorialName: self.tutorialNameTextField.text!, duration: Int(self.durationValue.text!)!, difficulty: Int(self.difficultyValue.text!)!)
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! AddTutorialStep
        vc.tutorial = tutorial
    }

}

extension TutorialUploadViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {

        guard let image = info["UIImagePickerControllerOriginalImage"] as? UIImage else { return }
        mainImageView.image = image
        dismiss(animated: true, completion: nil)

    }
}

