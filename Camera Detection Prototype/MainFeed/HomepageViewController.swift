//  HomepageViewController.swift
//  Beauty Blend
//  Created by Amy Wichelow on 26/02/2018.
//  Copyright © 2018 Amy Wichelow. All rights reserved.

import UIKit
import Firebase
import FirebaseAuth
import Floaty

class HomepageViewController: UICollectionViewController, UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating, UICollectionViewDelegateFlowLayout, FloatyDelegate {
    
    
    var floaty = Floaty()
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status and drop into background
        view.endEditing(true)
    }
    
    func updateSearchResults(for searchController: UISearchController) {

    }
    
    var tutorials = [Tutorial]()
    let tutorialRef = Database.database().reference().child("tutorials")
    
    var filtered:[String] = []
    var searchActive : Bool = false
    let searchController = UISearchController(searchResultsController: nil)
    
        let reuseIdentifier = "collCell"
        let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutFAB()

        let nib = UINib(nibName: "CustomCell", bundle: nil)
        collectionView?.register(nib, forCellWithReuseIdentifier: reuseIdentifier)
        
        tutorialRef.observeSingleEvent(of: .value, with: { snapshot in

            for tutorials in snapshot.children {
                if let data = tutorials as? DataSnapshot {
                    if let tutorial = Tutorial(snapshot: data) {
                        self.tutorials.append(tutorial)
                    }
                }
            }
            self.collectionView?.reloadData()
        })

    
    }
    
    
    func layoutFAB() {
        let item = FloatyItem()
        item.handler = { item in
            
        }
        
        floaty.addItem("Upload", icon: UIImage(named: "settings")) { item in
            self.performSegue(withIdentifier: "TutorialUpload", sender: nil)
            
        }
        floaty.addItem("Profile", icon: UIImage(named: "palette")) { item in
            self.performSegue(withIdentifier: "profileViewController", sender: nil)
            
        }
        floaty.addItem("Logout", icon: UIImage(named: "")) { item in
            
            do {
                try Auth.auth().signOut()
                print(Auth.auth().currentUser)
            } catch (let error) {
                print((error as NSError).code)
            }
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController")
            self.present(vc!, animated: true, completion: nil)
            
        }
        
        floaty.paddingX = self.view.frame.width/2 - floaty.frame.width/2
        floaty.fabDelegate = self
        
        self.view.addSubview(floaty)
        
    }

    
//    @IBAction func UploadButton(_ sender: UIBarButtonItem) {
//        
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TutorialUploadViewController")
//        self.present(vc!, animated: true, completion: nil)
//        
//    }
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tutorials.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CustomCell
        let tutorial = tutorials[indexPath.row]
        
        cell.isSelected = false
        cell.tutorialName?.text = tutorial.tutorialName
        cell.username.text = tutorial.user
        cell.duration.text = "\(tutorial.duration)"
        cell.animate()
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showTutorial"{
            let vc = segue.destination as! StepViewContoller
            vc.tutorial = sender as! Tutorial
        }
        
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        collectionView.deselectItem(at: indexPath, animated: true)
        let tutorial = tutorials[indexPath.row]
        performSegue(withIdentifier: "showTutorial", sender: tutorial)
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                    layout collectionViewLayout: UICollectionViewLayout,
                    sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 170, height: 300)
    }

    func collectionView(_ collectionView: UICollectionView,
                    layout collectionViewLayout: UICollectionViewLayout,
                    insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
}
