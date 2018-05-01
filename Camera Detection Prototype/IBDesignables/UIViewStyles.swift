//
//  UIViewStyles.swift
//  Camera Detection Prototype
//
//  Created by Amy Wichelow on 26/02/2018.
//  Copyright © 2018 Amy Wichelow. All rights reserved.
//

import UIKit

class UIViewStyles: UIView {
    
        
        @IBInspectable var shadow: Bool {
            get {
                return layer.shadowOpacity > 0.0
            }
            set {
                if newValue == true {
                    self.addShadow()
                }
            }
        }
        
        @IBInspectable var cornerRadius: CGFloat {
            get {
                return self.layer.cornerRadius
            }
            set {
                self.layer.cornerRadius = newValue
                
                // Don't touch the masksToBound property if a shadow is needed in addition to the cornerRadius
                if shadow == false {
                    self.layer.masksToBounds = true
                }
            }
        }
        
        
        func addShadow(shadowColor: CGColor = UIColor.lightGray.cgColor,
                       shadowOffset: CGSize = CGSize(width: 0, height: 2),
                       shadowOpacity: Float = 0.3,
                       shadowRadius: CGFloat = 3.2) {
            layer.shadowColor = shadowColor
            layer.shadowOffset = shadowOffset
            layer.shadowOpacity = shadowOpacity
            layer.shadowRadius = shadowRadius
        }
        
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
