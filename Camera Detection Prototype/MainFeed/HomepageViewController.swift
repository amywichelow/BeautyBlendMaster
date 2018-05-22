//  HomepageViewController.swift
//  Beauty Blend
//  Created by Amy Wichelow on 26/02/2018.
//  Copyright © 2018 Amy Wichelow. All rights reserved.
import UIKit
import Firebase
import FirebaseAuth
import Floaty


class HomepageViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout,UISearchControllerDelegate, UISearchBarDelegate, FloatyDelegate {
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(HomepageViewController.handleRefresh(_:)),
                                 for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor(red: 142, green: 117, blue: 179, alpha: 1.0)
        
        return refreshControl
    }()

    var floaty = Floaty()
    
    var tutorials = [Tutorial]()

    let tutorialRef = Database.database().reference().child("tutorials")
    
    var filtered = [Tutorial]()
    var searchActive : Bool = false
    let searchController = UISearchController(searchResultsController: nil)
    
    let reuseIdentifier = "collCell"
    let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.collectionView?.addSubview(self.refreshControl)
        
        self.searchController.searchResultsUpdater = self
        self.searchController.delegate = self
        self.searchController.searchBar.delegate = self

        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.dimsBackgroundDuringPresentation = true
        self.searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search tutorials"
        searchController.searchBar.sizeToFit()
        definesPresentationContext = true

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
            
            self.tutorials = self.tutorials.sorted(by: { $0.timestamp > $1.timestamp })
            
            self.collectionView?.reloadData()

        })

}

    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        
        self.collectionView?.reloadData()
        refreshControl.endRefreshing()
    }
    
    func layoutFAB() {
            let item = FloatyItem()
            item.handler = { item in
            
        }
        
        floaty.addItem("Upload", icon: UIImage(named: "uploadIconAsset 32")) { item in
            self.performSegue(withIdentifier: "uploadViewController", sender: nil)
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

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if isFiltering() {
            return filtered.count
        }
            return tutorials.count
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        self.navigationController?.popToRootViewController(animated: true)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        collectionView!.reloadData()
    }

    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }

    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }

    func filterContentForSearchText(_ searchText: String) {

        filtered = tutorials.filter({ Tutorial -> Bool in
            return Tutorial.tutorialName.lowercased().contains(searchText.lowercased())
        })

        collectionView!.reloadData()
    }
    
    
//    func updateSearchResults(for searchController: UISearchController) {
//        let searchString = searchController.searchBar.text
//
//        filtered.removeAll()
//
//        filtered = tutorials.filter({ tutorial -> Bool in
//
//            return tutorial.tutorialName.lowercased() != searchString!.lowercased()
//
//        })
//
//        collectionView?.reloadData()
//
//    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CustomCell
        let tutorialRef = tutorials[indexPath.row]
        let tutorial: Tutorial
    
        if isFiltering() {
            tutorial = filtered[indexPath.row]
        } else {
            tutorial = tutorials[indexPath.row]
        }
        
        cell.isSelected = false
        cell.tutorialName?.text = tutorialRef.tutorialName
        cell.username.text = tutorialRef.user
        cell.duration.text = "\(tutorialRef.duration) minutes"
        cell.difficulty.text = "\(tutorialRef.difficulty)"
        
        Storage.storage().reference(withPath: tutorialRef.mainImageId!).getData(maxSize: 2 * 1024 * 1024, completion: { data, error in
            print(data as Any)
            tutorial.mainImage = UIImage(data: data!)
            cell.mainTutorialImage.image = tutorialRef.mainImage
        })
       
        cell.animate()
        
        print("\(tutorial.difficulty)")
        
        if cell.difficulty.text == "\(1)" {
            cell.difficultyImage.image = UIImage(named: "difficulty1")
        }
        if cell.difficulty.text == "\(2)" {
            cell.difficultyImage.image = UIImage(named: "difficulty2")
        }
        if cell.difficulty.text == "\(3)" {
            cell.difficultyImage.image = UIImage(named: "difficulty3")
        }
        if cell.difficulty.text == "\(4)" {
            cell.difficultyImage.image = UIImage(named: "difficulty4")
        }
        if cell.difficulty.text == "\(5)" {
            cell.difficultyImage.image = UIImage(named: "difficulty5")
        }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showTutorial"{
            let vc = segue.destination as! StepViewContoller
            vc.tutorial = sender as! Tutorial
        }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
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

extension HomepageViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {

        filterContentForSearchText(searchController.searchBar.text!)

    }

}
