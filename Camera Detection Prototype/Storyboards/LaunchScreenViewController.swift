import UIKit

class LaunchScreenViewController: UIViewController {
    
    
    @IBOutlet weak var animationContainer: UIView!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        spinner.startAnimating()
        
//        spinner.stopAnimating()
//        
//        spinner.isHidden = false
//        
        
        
    }
    
    
}
