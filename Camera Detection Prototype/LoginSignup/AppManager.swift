//  ImageViewController.swift
//  Beauty Blend
//  Created by Amy Wichelow on 08/11/2017.
//  Copyright © 2017 Amy Wichelow. All rights reserved.

import UIKit
import Firebase

class AppManager {
    
    static let shared = AppManager()
    
    let storyboard = UIStoryboard(name: "Main", bundle:nil)
    var appContainer: AppContainerViewController!
    
    private init() { }
    
    func showApp() {
        
        var viewController: UIViewController
        if Auth.auth().currentUser == nil {
            viewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
        } else {
            viewController = storyboard.instantiateViewController(withIdentifier: "HomepageViewControllerContainer")
        }
        
        appContainer.present(viewController, animated:true, completion: nil)
    }
    

    
}
