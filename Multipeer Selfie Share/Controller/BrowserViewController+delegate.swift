//
//  BrowserViewController+delegate.swift
//  Multipeer Selfie Share
//
//  Created by ruijia lin on 7/3/18.
//  Copyright © 2018 ruijia lin. All rights reserved.
//

import Foundation
import MultipeerConnectivity
import RealmSwift

extension BrowserViewController: CameraServiceManagerDelegate {
    func updateTimerLabel(timerValue: String?) {
        
    }
    
    func switchCameraButtonTapped(manager: CameraServiceManager, switchCameraRequest: String?) {
        
    }
    
    func connectedDevicesChanged(manager: CameraServiceManager, state: MCSessionState, connectedDevices: [String]) {
        
    }
    
    func shutterButtonTapped(manager: CameraServiceManager, data: Data?) {
        guard let data = data else {return}
        let photo = Photo()
        photo.photoData = data
        photo.timestamp = Date()
        
        // instantiate realm object and write image data to realm object
        do {
            let realm = try Realm()
            do {
                try realm.write {
                    realm.add(photo)
                }
            } catch {
                print("Failed to write to Realm")
            }
        } catch {
            print("Failed to get default Realm")
        }
        
        // segue to collection view to see the captured photos
        
        // re-enable shutter button and stop the timer bool
        DispatchQueue.main.async {
            self.browserView.thumbnailImageView.image = UIImage(data: data)
            self.browserView.thumbnailImageView.isHidden = false
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

