//
//  PhotoDetailViewController+delegate.swift
//  Multipeer Selfie Share
//
//  Created by ruijia lin on 7/20/18.
//  Copyright © 2018 ruijia lin. All rights reserved.
//

import UIKit
import Chameleon

extension PhotoDetailViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selectedCell = collectionView.cellForItem(at: indexPath)
        selectedCell?.backgroundColor = UIColor.flatYellow()
        
//         apply selected filter to image
//        switch selectedCell {
//        case <#pattern#>:
//            <#code#>
//        default:
//            <#code#>
//        }
    }
}

extension PhotoDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterModel.filters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = photoDetailView.filterCollectionView.dequeueReusableCell(withReuseIdentifier: filterCell, for: indexPath) as? FilterCell else {
        
            let cell = photoDetailView.filterCollectionView.dequeueReusableCell(withReuseIdentifier: filterCell, for: indexPath)

            return cell
        }
        
        cell.filterLabel.text = filterModel.filters[indexPath.row].stringValue()
        
        return cell
    }
    
    
}

extension PhotoDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let filterString = filterModel.filters[indexPath.row].stringValue() as? NSString else {return CGSize(width: 30, height: 20)}
        
        let calculatedSize = filterString.size(withAttributes: nil)
        let calculatedWidth = calculatedSize.width * 1.2
        let calculatedHeight = calculatedSize.height
        return CGSize(width: calculatedWidth, height: calculatedHeight)
    }
}
