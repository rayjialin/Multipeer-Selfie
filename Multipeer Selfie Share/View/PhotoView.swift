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
    
    let sweetAlert = SweetAlert()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupView()
        
    }
    
    private func setupView() {
        footerContainerView.isHidden = true
        connectButton.setImage(#imageLiteral(resourceName: "settingIcon"), for: .normal)
        flashButton.setImage(#imageLiteral(resourceName: "sortIcon"), for: .normal)
        timerButton.setImage(#imageLiteral(resourceName: "deleteIcon"), for: .normal)
    }
    
    
    
    
}
