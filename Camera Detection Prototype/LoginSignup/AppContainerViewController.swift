//  ImageViewController.swift
//  Beauty Blend
//  Created by Amy Wichelow on 08/11/2017.
//  Copyright © 2017 Amy Wichelow. All rights reserved.

import UIKit

class AppContainerViewController: UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AppManager.shared.appContainer = self
        AppManager.shared.showApp()
    }
    
}
