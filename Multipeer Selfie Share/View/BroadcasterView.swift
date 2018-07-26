//
//  BroadcasterView.swift
//  Multipeer Selfie Share
//
//  Created by ruijia lin on 7/3/18.
//  Copyright © 2018 ruijia lin. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class BroadcasterView: BaseView {
    
    var recordingStartButton: UIButton!
    var recordingEndButton: UIButton!
    var videoLengthLabel: UILabel!
    
    var lastCapturedPhoto: UIImage? {
        didSet{
            thumbnailImageView.image = lastCapturedPhoto
            thumbnailImageView.isHidden = false
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        recordingStartButton = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        recordingStartButton.backgroundColor = UIColor.flatBlue()

        recordingEndButton = UIButton(frame: CGRect(x: 200, y: 100, width: 100, height: 100))
        recordingEndButton.backgroundColor = UIColor.flatPink()

        videoLengthLabel?.text = "0"
        videoLengthLabel = UILabel(frame: CGRect(x: 100, y: 200, width: 100, height: 50))

        self.addSubview(recordingStartButton)
        self.addSubview(recordingEndButton)
        self.addSubview(videoLengthLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
