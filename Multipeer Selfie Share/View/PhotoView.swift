//
//  PhotoView.swift
//  Multipeer Selfie Share
//
//  Created by ruijia lin on 7/21/18.
//  Copyright © 2018 ruijia lin. All rights reserved.
//

import UIKit
import CollectionViewSlantedLayout

class PhotoView: BaseView {

    let photoCollectionView: UICollectionView = {
        let layout = CollectionViewSlantedLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        footerContainerView.isHidden = true
        connectButton.setImage(#imageLiteral(resourceName: "settingIcon"), for: .normal)
        flashButton.setImage(#imageLiteral(resourceName: "sortIcon"), for: .normal)
        timerButton.setImage(#imageLiteral(resourceName: "deleteIcon"), for: .normal)
        
        self.addSubview(photoCollectionView)
        
        // setup constraint
        photoCollectionView.topAnchor.constraint(equalTo: headerContainerView.bottomAnchor).isActive = true
        photoCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        photoCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        photoCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
    }
    
    
    
    
}
