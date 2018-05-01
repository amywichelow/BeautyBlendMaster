import UIKit

class Texter: NSObject, UITextViewDelegate {
  
  var viewController: UIViewController!
  var tempTextView: UITextView!
  
  var forTextView: UITextView?
  var forTextField: UITextField?
  
  
  override init() {
    super.init()
    NotificationCenter.default.addObserver(self, selector: #selector(test(notification:)), name: Notification.Name.UIKeyboardDidShow, object: nil)
  }
  
  
  
  @objc func test(notification: NSNotification) {
    
    var yOffset: CGFloat = 0
    
    yOffset += UIApplication.shared.statusBarFrame.height
    
    if let navbarHeight = viewController.navigationController?.navigationBar.frame.height {
      yOffset += navbarHeight
    }
    
    var keyboardHeight: CGFloat = 0
    
    if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
      keyboardHeight = keyboardSize.height
    }
    
    let height = viewController.view.frame.height - keyboardHeight
    
    let frame = CGRect(x: 0, y: -height, width: viewController.view.frame.width, height: height)
    tempTextView = UITextView(frame: frame)
    tempTextView?.backgroundColor = .blue
    tempTextView?.becomeFirstResponder()
    tempTextView?.delegate = self
    viewController.view.addSubview(tempTextView!)
    animateIn(to: yOffset)
  }
  
  func animateIn(to position: CGFloat) {
    UIView.animate(withDuration: 0.2) { [unowned self] in
      let frame = CGRect(x: 0, y: position, width: self.tempTextView.frame.width, height: self.tempTextView.frame.height)
      self.tempTextView.frame = frame
    }
  }
  
  
  func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    if text == "\n" {
      
      if let forTextView = forTextView {
        forTextView.text = tempTextView.text
      }
      
      if let forTextField = forTextField {
        forTextField.text = tempTextView.text
      }
      
      forTextView = nil
      forTextField = nil
      
      tempTextView!.resignFirstResponder()
      tempTextView!.removeFromSuperview()
      return false
    }
    return true
  }
  
  
  
}
