import UIKit

class ShareTutorialViewController: UIViewController {
    
    @IBOutlet weak var shareResultImageView: UIImageView!
    
    @IBOutlet weak var takePhotoButton: UIButton!
    
    @IBAction func takePhotoResult(_ sender: Any) {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: {action in
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            }))
            alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { action in
                imagePickerController.sourceType = .photoLibrary
                self.present(imagePickerController, animated: true, completion: nil)
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        self.takePhotoButton.isHidden = true
        
    }
    
    @IBAction func shareImage(_ sender: Any) {
        
        let vc = UIActivityViewController(activityItems: [shareResultImageView.image!], applicationActivities: nil)
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func finishTutorialButton(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomepageViewControllerContainer")
        self.present(vc!, animated: true, completion: nil)
    }
}

extension ShareTutorialViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        guard let image = info["UIImagePickerControllerOriginalImage"] as? UIImage else { return }
        shareResultImageView.image = image
        dismiss(animated: true, completion: nil)
    }
}
