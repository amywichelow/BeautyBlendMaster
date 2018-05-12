//  HomepageViewController.swift
//  Beauty Blend
//  Created by Amy Wichelow on 26/02/2018.
//  Copyright © 2018 Amy Wichelow. All rights reserved.

import UIKit
import Firebase
import FirebaseAuth
import Floaty


class HomepageViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout,UISearchControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating, FloatyDelegate {

    var floaty = Floaty()

    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status and drop into background
        view.endEditing(true)
    }
    
    @IBAction func searchBar(_ sender: Any) {
    }
    
    var tutorials = [Tutorial]()
    var items = ["hello"]
    let tutorialRef = Database.database().reference().child("tutorials")
    
    var filtered:[String] = []
    var searchActive : Bool = false
    let searchController = UISearchController(searchResultsController: nil)
    
        let reuseIdentifier = "collCell"
        let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchController.searchResultsUpdater = self
        self.searchController.delegate = self
        self.searchController.searchBar.delegate = self

        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.dimsBackgroundDuringPresentation = true
        self.searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search tutorials"
        searchController.searchBar.sizeToFit()

        searchController.searchBar.becomeFirstResponder()

        self.navigationItem.titleView = searchController.searchBar
        
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
        
        floaty.addItem("Upload", icon: UIImage(named: "uploadIconAsset 32")) { item in
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "TutorialUploadViewController")
            self.present(vc!, animated: true, completion: nil)
        }
        floaty.addItem("Profile", icon: UIImage(named: "profileIconAsset 33")) { item in
            self.performSegue(withIdentifier: "profileViewController", sender: nil)
            
        }
        floaty.addItem("Logout", icon: UIImage(named: "logoutIconAsset 31")) { item in
            
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
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchString = searchController.searchBar.text
        
        filtered = items.filter({ (item) -> Bool in
            let countryText: NSString = item as NSString

            return (countryText.range(of: searchString!, options: NSString.CompareOptions.caseInsensitive).location) != NSNotFound
        })

        collectionView?.reloadData()

    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if searchActive {
            return filtered.count
        }
        else
        {
            return tutorials.count
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true
        collectionView?.reloadData()
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        collectionView!.reloadData()
    }

    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        if !searchActive {
            searchActive = true
            collectionView?.reloadData()
        }

        searchController.searchBar.resignFirstResponder()
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CustomCell
        let tutorial = tutorials[indexPath.row]
        
        cell.isSelected = false
        cell.tutorialName?.text = tutorial.tutorialName
        cell.username.text = tutorial.user
        cell.duration.text = "\(tutorial.duration)"
        //cell.difficulty.image = "\(tutorial.duration)"
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
