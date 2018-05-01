import UIKit


class ViewController: UIViewController {
  
  @IBOutlet weak var testView: UITextView!
  
  var textView: UITextView?
  
  let test = Texter()

  override func viewDidLoad() {
    super.viewDidLoad()
    test.viewController = self
  }

}

extension ViewController: UITextFieldDelegate, UITextViewDelegate {
  
  func textViewDidBeginEditing(_ textView: UITextView) {
    test.forTextView = textView
  }
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    test.forTextField = textField
  }

}

