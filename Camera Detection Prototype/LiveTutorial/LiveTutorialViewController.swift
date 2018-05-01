//  ImageViewController.swift
//  Beauty Blend
//  Created by Amy Wichelow on 08/11/2017.
//  Copyright © 2017 Amy Wichelow. All rights reserved.

import FirebaseAuth
import UIKit
import Firebase

class LiveTutorialViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
   
    
    @IBOutlet weak var takePhotoButton: UIButton!
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func takePhoto(_ sender: UIButton) {
        let picker = UIImagePickerController()
        picker.delegate = self
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: {action in
                picker.sourceType = .camera
                self.present(picker, animated: true, completion: nil)
            }))
        }
        alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { action in
            picker.sourceType = .photoLibrary
            self.present(picker, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        dismiss(animated: true, completion: nil)
        image = info[UIImagePickerControllerOriginalImage] as? UIImage
            performSegue(withIdentifier: "showImageSegue", sender: self)
        }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showImageSegue" {
            if let imageViewController = segue.destination as? StepOne {
                imageViewController.image = self.image

            }
        }
    }

}



