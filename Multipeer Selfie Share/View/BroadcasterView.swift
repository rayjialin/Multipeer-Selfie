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

class BroadcasterView: UIView {
    
    let previewView = AVPreviewView()
    let session = AVCaptureSession()
    let broadcasterViewController = BroadcastViewController()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        func configureCameraController() {
            broadcasterViewController.prepare {(error) in
                if let error = error {
                    print(error)
                }
                
                try? self.broadcasterViewController.displayPreview(on: self)
            }
        }
        
        configureCameraController()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
