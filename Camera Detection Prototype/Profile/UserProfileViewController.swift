import UIKit
import Firebase
import FirebaseStorage

class UserProfileViewController: UIViewController {
    
    let ref = Database.database().reference().child("users").child(Auth.auth().currentUser!.uid).child("tutorials")
    
    var tutorial = [Tutorial]()
    
    @IBOutlet weak var userUsername: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileTableView: UITableView!
    
    @IBAction func editProfileButton(_ sender: Any) {
        
    }
    
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

    override func viewDidLoad() {
        
        ref.observe(.value, with: { snapshot in
            self.tutorial.removeAll()
            for tutorial in snapshot.children {
                if let data = tutorial as? DataSnapshot {
                    if let tutorial = Tutorial(snapshot: data) {
                        self.tutorial.append(tutorial)
                    }
                }
            }
            self.profileTableView.reloadData()
        })
        
        let uid = Auth.auth().currentUser!.uid
        let userRef = Database.database().reference(withPath: "users/\(uid)")

        userRef.observeSingleEvent(of: .value, with: { snapshot in
            if let user = Users(snapshot: snapshot) {
                self.userUsername.text = user.username
                print(user.userImageUrl)
                
                let storageRef = Storage.storage().reference(withPath: user.userImageUrl!).getData(maxSize: 2 * 1024 * 1024, completion: { data, error in
                    print(data)
                    let image = UIImage(data: data!)
                    self.profileImage.image = image
                })
            }
            print(snapshot)
        })
        
        profileTableView.delegate = self
            profileTableView.dataSource = self
    }
    
}

extension UserProfileViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 73
        
    }
}

extension UserProfileViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tutorial.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = profileTableView.dequeueReusableCell(withIdentifier: "cell") as! ShowTutorialCell
        
        let user = tutorial[indexPath.row]
        cell.tutorialNameLabel.text = user.tutorialName
        cell.durationLabel.text = "\(user.duration)"
       
        return cell
        
    }

}
