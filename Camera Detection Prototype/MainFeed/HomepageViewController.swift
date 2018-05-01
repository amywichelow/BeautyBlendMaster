//  HomepageViewController.swift
//  Beauty Blend
//  Created by Amy Wichelow on 26/02/2018.
//  Copyright © 2018 Amy Wichelow. All rights reserved.

import UIKit
import Firebase
import FirebaseAuth

class HomepageViewController: UICollectionViewController, UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating, UICollectionViewDelegateFlowLayout {
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

    
    @IBAction func UploadButton(_ sender: UIBarButtonItem) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TutorialUploadViewController")
        self.present(vc!, animated: true, completion: nil)
        
    }
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tutorials.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CustomCell
        let tutorial = tutorials[indexPath.row]
        
        cell.tutorialName?.text = tutorial.tutorialName
        cell.username.text = tutorial.user
        cell.duration.text = "\(tutorial.duration)"
        cell.animate()
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
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
