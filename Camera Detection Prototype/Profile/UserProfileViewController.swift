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
            print(Auth.auth().currentUser?.uid as Any)
        } catch (let error) {
            print((error as NSError).code)
        }
        
        dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        
        let uid = Auth.auth().currentUser!.uid
        let userRef = Database.database().reference(withPath: "users/\(uid)")
        
        userRef.observeSingleEvent(of: .value, with: { snapshot in
            if let user = Users(snapshot: snapshot) {
                self.userUsername.text = user.username
                print(user.userImageUrl as Any)
                
                _ = Storage.storage().reference(withPath: user.userImageUrl!).getData(maxSize: 2 * 1024 * 1024, completion: { data, error in
                    print(data as Any)
                    let image = UIImage(data: data!)
                    self.profileImage.image = image
                })
            }
            print(snapshot)
        })
        
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
        
            self.profileTableView.delegate = self
            self.profileTableView.dataSource = self
        }
}

extension UserProfileViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 120
        
    }
}

extension UserProfileViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tutorial.count
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let destination = StepViewContoller()
        navigationController?.pushViewController(destination, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = profileTableView.dequeueReusableCell(withIdentifier: "cell") as! ShowTutorialCell
        
        let user = tutorial[indexPath.row]
        cell.tutorialNameLabel.text = user.tutorialName
        cell.durationLabel.text = "\(user.duration)"
        cell.difficultyLabel.text = "\(user.difficulty)"
        
        Storage.storage().reference(withPath: user.mainImageId!).getData(maxSize: 2 * 1024 * 1024, completion: { data, error in
            user.mainImage = UIImage(data: data!)
            cell.mainTutorialImage.image = user.mainImage
        })
        
        if cell.difficultyLabel.text == "\(1)" {
            cell.difficultyImage.image = UIImage(named: "difficulty1")
        }
        if cell.difficultyLabel.text == "\(2)" {
            cell.difficultyImage.image = UIImage(named: "difficulty2")
        }
        if cell.difficultyLabel.text == "\(3)" {
            cell.difficultyImage.image = UIImage(named: "difficulty3")
        }
        if cell.difficultyLabel.text == "\(4)" {
            cell.difficultyImage.image = UIImage(named: "difficulty4")
        }
        if cell.difficultyLabel.text == "\(5)" {
            cell.difficultyImage.image = UIImage(named: "difficulty5")
        }
       
        return cell
        
    }

}
