//
//  BrowserViewController.swift
//  Multipeer Selfie Share
//
//  Created by ruijia lin on 7/2/18.
//  Copyright © 2018 ruijia lin. All rights reserved.
//
//  This class is hanlding devices which are registered to receive captured photos from Broadcasting devices

import UIKit

class BrowserViewController: UIViewController {
    
//    let cameraService = CameraServiceManager()
    var savePhoto: Bool?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let browserView = BrowserView.init(frame: view.frame)
        view.addSubview(browserView)
//        cameraService.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        cameraService.serviceBrowser.startBrowsingForPeers()
    }
    
}

