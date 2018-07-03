//
//  BroadcastViewController.swift
//  Multipeer Selfie Share
//
//  Created by ruijia lin on 7/2/18.
//  Copyright © 2018 ruijia lin. All rights reserved.
//
//  The class is handling device which is registered to act as camera and holds information about all the connect discovery devices

import UIKit
import MultipeerConnectivity

class BroadcastViewController: UIViewController {
    
    let cameraService = CameraServiceManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cameraService.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        cameraService.serviceBroadcaster.startAdvertisingPeer()
    }
    
}

extension BroadcastViewController: CameraServiceManagerDelegate {
    func connectedDevicesChanged(manager: CameraServiceManager, state: MCSessionState, connectedDevices: [String]) {
        DispatchQueue.main.async {
            switch(state) {
            case .connected:
                break
            case .connecting:
                break
            case .notConnected:
                break
            }
        }
    }
    
    func shutterButtonTapped(manager: CameraServiceManager, _ sendPhoto: Bool) {
        
    }
    
    func toggleFlash(manager: CameraServiceManager) {
        
    }
    
    func acceptInvitation(manager: CameraServiceManager) {
        
    }
    
    func didStartReceivingData(manager: CameraServiceManager, withName resourceName: String, withProgress progress: Progress) {
        
    }
    
    func didFinishReceivingData(manager: CameraServiceManager, url: NSURL) {
        
    }
    
    
}
