//
//  PhotosViewController+delegate.swift
//  Multipeer Selfie Share
//
//  Created by ruijia lin on 7/21/18.
//  Copyright © 2018 ruijia lin. All rights reserved.
//

import UIKit
import CollectionViewSlantedLayout

extension PhotosViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return medias.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: mediaId, for: indexPath) as! CustomCollectionCell
        
        if let mediaData = medias[indexPath.row].thumbnail, let image = UIImage(data: mediaData) {
            cell.image = image
        }
        
        if let layout = collectionView.collectionViewLayout as? CollectionViewSlantedLayout {
            cell.contentView.transform = CGAffineTransform(rotationAngle: layout.slantingAngle)
        }
        
        return cell
    }
}

extension PhotosViewController: CollectionViewDelegateSlantedLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        NSLog("Did select item at indexPath: [\(indexPath.section)][\(indexPath.row)]")
        
        performSegue(withIdentifier: "segueToDetails", sender: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: CollectionViewSlantedLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGFloat {
        return collectionViewLayout.scrollDirection == .vertical ? 275 : 325
    }
}

extension PhotosViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let collectionView = self.collectionView else {return}
        guard let visibleCells = collectionView.visibleCells as? [CustomCollectionCell] else {return}
        for parallaxCell in visibleCells {
            let yOffset = ((collectionView.contentOffset.y - parallaxCell.frame.origin.y) / parallaxCell.imageHeight) * yOffsetSpeed
            let xOffset = ((collectionView.contentOffset.x - parallaxCell.frame.origin.x) / parallaxCell.imageWidth) * xOffsetSpeed
            parallaxCell.offset(CGPoint(x: xOffset,y :yOffset))
        }
    }
}
