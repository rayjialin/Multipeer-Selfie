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
    func toggleRecording(manager: CameraServiceManager, toggleRecordingRequest: String?) {
        
    }
    
    func updateTimerLabel(timerValue: String?) {
        
    }
    
    func switchCameraButtonTapped(manager: CameraServiceManager, switchCameraRequest: String?) {
        
    }
    
    func connectedDevicesChanged(manager: CameraServiceManager, state: MCSessionState, connectedDevices: [String]) {
        
    }
    
    func transmitVideoData(mediaData: MediaData?) {
        guard let data = mediaData else {return}
        let mediaData = MediaData()
        mediaData.mediaData = data.mediaData
        mediaData.timestamp = data.timestamp
        mediaData.isVideo = data.isVideo
        mediaData.thumbnail = data.thumbnail
        
        // segue to collection view to see the captured photos
        
        // re-enable shutter button and stop the timer bool
        DispatchQueue.main.async {
            self.browserView.progressBarView.stopAnimating()
            guard let thumbnailData = mediaData.thumbnail else {return}
            self.browserView.thumbnailImageView.image = UIImage(data: thumbnailData)
            self.browserView.thumbnailImageView.isHidden = false
            self.browserView.takePhotoButton.isEnabled = true
            self.isTimerRunning = false
            RealmManager.shareInstance.wrtieToRealm(object: mediaData)
        }
    }
    
    func transmitPhotoData(mediaData: MediaData?) {
        guard let data = mediaData else {return}
        let mediaData = MediaData()
        mediaData.mediaData = data.mediaData
        mediaData.timestamp = data.timestamp
        mediaData.isVideo = data.isVideo
        mediaData.thumbnail = data.thumbnail
        
        // segue to collection view to see the captured photos
        
        // re-enable shutter button and stop the timer bool
        DispatchQueue.main.async {
            self.browserView.progressBarView.stopAnimating()
            guard let thumbnailData = mediaData.thumbnail else {return}
            self.browserView.thumbnailImageView.image = UIImage(data: thumbnailData)
            self.browserView.thumbnailImageView.isHidden = false
            self.browserView.takePhotoButton.isEnabled = true
            self.isTimerRunning = false
            RealmManager.shareInstance.wrtieToRealm(object: mediaData)
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

