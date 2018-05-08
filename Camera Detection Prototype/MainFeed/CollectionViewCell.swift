//  CollectionViewCell.swift
//  Beauty Blend
//  Created by Amy Wichelow on 27/02/2018.
//  Copyright © 2018 Amy Wichelow. All rights reserved.

import Foundation
import UIKit

class CustomCell: UICollectionViewCell {
    
    @IBOutlet weak var tutorialName: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var duration: UILabel!
    @IBOutlet weak var difficulty: UIImageView!
    
    
    @IBAction func goButton(_ sender: Any) {
        
    }
    
    @IBOutlet weak var mainTutorialImage: UIImageView!
    
    
    override func prepareForReuse() {
        tutorialName.text = nil
        tutorialName.alpha = 0
    }
 
    func animate() {
        UIView.animate(withDuration: 2.0) {
            self.tutorialName.alpha = 1.0
        }
    }
    
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
            
        }
    }
}
