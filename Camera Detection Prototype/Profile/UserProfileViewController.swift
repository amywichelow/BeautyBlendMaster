import UIKit
import Firebase
import FirebaseStorage

class UserProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var appContainer: AppContainerViewController!
    
    @IBAction func logoutButton(_ sender: Any) {
        
        do {
            try Auth.auth().signOut()
            print(Auth.auth().currentUser)
            
        } catch (let error) {
            print((error as NSError).code)
        }
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController")
        self.present(vc!, animated: true, completion: nil)
        
        
    }
    
    @IBOutlet weak var userUsername: UILabel!
    
    @IBOutlet weak var profileTableView: UITableView!
    
    //show up user uploads..????
    
    let tutorialUpload = [""]
    

    
    override func viewDidLoad() {
    
        
        let uid = Auth.auth().currentUser!.uid
        
        let userRef = Database.database().reference(withPath: "users/\(uid)")

        userRef.observeSingleEvent(of: .value, with: { snapshot in
            if let user = Users(snapshot: snapshot) {
                self.userUsername.text = user.username
            }
            print(snapshot)
        })

        
        profileTableView.delegate = self
            profileTableView.dataSource = self
    
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tutorialUpload.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = profileTableView.dequeueReusableCell(withIdentifier: "cell")
        
        cell?.textLabel?.text = tutorialUpload[indexPath.row]
        
        return cell!
        
    }
    
}

