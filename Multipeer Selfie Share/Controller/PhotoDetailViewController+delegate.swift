//
//  PhotoDetailViewController+delegate.swift
//  Multipeer Selfie Share
//
//  Created by ruijia lin on 7/20/18.
//  Copyright © 2018 ruijia lin. All rights reserved.
//

import UIKit

extension PhotoDetailViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
   
        // de-highlight all other selected cell
//        guard let indexPaths = collectionView.indexPathsForSelectedItems else {return}
//        for index in indexPaths {
//            let selectedCell = collectionView.cellForItem(at: index) as? FilterCell
//            selectedCell?.bottomBar.isHidden = true
//        }
        
        // highlight the selected cell
        let selectedCell = collectionView.cellForItem(at: indexPath) as? FilterCell
        
        // apply selected filter to image
//        selectedCell?.bottomBar.isHidden = false
//        guard let filterText = selectedCell?.filterLabel.text else {return}
//        applyFilter(filter: filterText)
        
        if selectedCell?.bottomBar.isHidden == true {
            selectedCell?.bottomBar.isHidden = false
            guard let filterText = selectedCell?.filterLabel.text else {return}
            applyFilter(filter: filterText)
        }else {
            selectedCell?.bottomBar.isHidden = true
            removeFilter()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let selectedCell = collectionView.cellForItem(at: indexPath) as? FilterCell
        selectedCell?.bottomBar.isHidden = true
        
        // remove selected filter from image
        removeFilter()
    }
}

extension PhotoDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterOptions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = photoDetailView.filterCollectionView.dequeueReusableCell(withReuseIdentifier: filterCell, for: indexPath) as? FilterCell else {
        
            let cell = photoDetailView.filterCollectionView.dequeueReusableCell(withReuseIdentifier: filterCell, for: indexPath)
            return cell
        }
        
        cell.filterLabel.text = filterOptions[indexPath.row]
        return cell
    }
    
    
}

extension PhotoDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: photoDetailView.footerDetailContainer.frame.width / 3, height: photoDetailView.footerDetailContainer.frame.height)
    }
}

extension PhotoDetailViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view == gestureRecognizer.view {
            return true
        }
        return false
    }
}
