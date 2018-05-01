//
//  ExpandableCell.swift
//  Camera Detection Prototype
//
//  Created by Amy Wichelow on 27/02/2018.
//  Copyright © 2018 Amy Wichelow. All rights reserved.
//

import Foundation
import UIKit

class ExpandableCellViewController: UIViewController {
    
    let reuseIdentifier = "ExpandableCell"

    var collectionView: UICollectionView!
    var expandedCellIdentifier = "ExpandableCell"
    
    var cellWidth:CGFloat{
        return collectionView.frame.size.width
    }
    var expandedHeight : CGFloat = 200
    var notExpandedHeight : CGFloat = 50
    
    var dataSource = ["data0","data1","data2","data3","data4"]
    var isExpanded = [Bool]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isExpanded = Array(repeating: false, count: dataSource.count)
    }
}


extension ExpandableCellViewController:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        
        //cell.indexPath = indexPath
        //cell.delegate = self
        //configure Cell
        return cell
        
    }
}

extension ExpandableCellViewController:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if isExpanded[indexPath.row] == true{
            return CGSize(width: cellWidth, height: expandedHeight)
        }else{
            return CGSize(width: cellWidth, height: notExpandedHeight)
        }
        
    }
    
}

extension ExpandableCellViewController:ExpandedCellDelegate{
    func topButtonTouched(indexPath: IndexPath) {
        isExpanded[indexPath.row] = !isExpanded[indexPath.row]
        UIView.animate(withDuration: 0.8, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.9, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            self.collectionView.reloadItems(at: [indexPath])
        }, completion: { success in
            print("success")
        })
    }
}
