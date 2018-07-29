//
//  BroadcasterView.swift
//  Multipeer Selfie Share
//
//  Created by ruijia lin on 7/3/18.
//  Copyright © 2018 ruijia lin. All rights reserved.
//

import UIKit
import AVFoundation

class BroadcasterView: BaseView {
    
    var lastCapturedPhoto: UIImage? {
        didSet{
            thumbnailImageView.image = lastCapturedPhoto
            thumbnailImageView.isHidden = false
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
