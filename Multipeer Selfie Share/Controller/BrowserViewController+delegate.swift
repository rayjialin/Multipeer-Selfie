//
//  BrowserViewController+delegate.swift
//  Multipeer Selfie Share
//
//  Created by ruijia lin on 7/3/18.
//  Copyright © 2018 ruijia lin. All rights reserved.
//

import Foundation
import MultipeerConnectivity

extension BrowserViewController: CameraServiceManagerDelegate {
    func connectedDevicesChanged(manager: CameraServiceManager, state: MCSessionState, connectedDevices: [String]) {
        
    }
    
    func shutterButtonTapped(manager: CameraServiceManager, image: UIImage?) {
        guard let image = image else {return}
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
        DispatchQueue.main.async {
            self.browserView.thumbNailImage.image = image
            self.browserView.thumbNailImage.isHidden = false
            self.browserView.takePhotoButton.isEnabled = true
            self.isTimerRunning = false
        }
    }
    
    func toggleFlash(manager: CameraServiceManager, flashState: String) {
        
    }
    
    func acceptInvitation(manager: CameraServiceManager) {
        
    }
    
    func didStartReceivingData(manager: CameraServiceManager, withName resourceName: String, withProgress progress: Progress) {
        
    }
    
    func didFinishReceivingData(manager: CameraServiceManager, url: NSURL) {
        
    }
}

extension BrowserViewController: MCBrowserViewControllerDelegate {
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
}

