//
//  PhotosViewController.swift
//  Multipeer Selfie Share
//
//  Created by ruijia lin on 7/15/18.
//  Copyright © 2018 ruijia lin. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        self.navigationController?.isNavigationBarHidden = true
//        collectionViewSlantedLayout.isFirstCellExcluded = true
//        collectionViewSlantedLayout.isLastCellExcluded = true
    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        collectionView.reloadData()
//        collectionView.collectionViewLayout.invalidateLayout()
//    }
//
//    override var prefersStatusBarHidden : Bool {
//        return true
//    }
//
//    override var preferredStatusBarUpdateAnimation : UIStatusBarAnimation {
//        return UIStatusBarAnimation.slide
//    }
    
}

extension PhotosViewController: UICollectionViewDelegate {
    
}

extension PhotosViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoId", for: indexPath) as? PhotosCell else {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoId", for: indexPath)
            return cell
        }
        
//        cell.imageView.image = #imageLiteral(resourceName: "abc")
        cell.backgroundColor = .red
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
}

extension PhotosViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width / 3.5, height: view.frame.size.width / 3.5)
    }
    
}


