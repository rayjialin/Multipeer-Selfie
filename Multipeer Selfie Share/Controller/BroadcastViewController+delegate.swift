//
//  BroadcastViewController+delegate.swift
//  Multipeer Selfie Share
//
//  Created by ruijia lin on 7/4/18.
//  Copyright © 2018 ruijia lin. All rights reserved.
//

import AVFoundation
import MultipeerConnectivity
import RealmSwift

extension BroadcastViewController: CameraServiceManagerDelegate {
    
    func updateTimerLabel(timerValue: String?) {
        DispatchQueue.main.async {
            self.broadcasterView.timerLabel.isHidden = false
            self.broadcasterView.timerLabel.text = timerValue
        }
    }
    
    func switchCameraButtonTapped(manager: CameraServiceManager, switchCameraRequest: String?) {
        //Change camera source
        if let session = captureSession {
            //Indicate that some changes will be made to the session
            session.beginConfiguration()
            
            //Remove existing input
            guard let currentCameraInput: AVCaptureInput = session.inputs.first else {
                return
            }
            
            session.removeInput(currentCameraInput)
            
            //Get new input
            var newCamera: AVCaptureDevice! = nil
            if let input = currentCameraInput as? AVCaptureDeviceInput {
                newCamera = input.device.position == .back ? cameraWithPosition(position: .front) : cameraWithPosition(position: .back)
            }
            
            //Add input to session
            var error: NSError?
            var newVideoInput: AVCaptureDeviceInput!
            do {
                newVideoInput = try AVCaptureDeviceInput(device: newCamera)
            } catch let err as NSError {
                error = err
                newVideoInput = nil
            }
            
            if newVideoInput == nil || error != nil {
                print("Error creating capture device input: \(error?.localizedDescription ?? "")")
            } else {
                session.addInput(newVideoInput)
            }
            
            //Commit all the configuration changes at once
            session.commitConfiguration()
        }
    }
    
    // Find a camera with the specified AVCaptureDevicePosition, returning nil if one is not found
    private func cameraWithPosition(position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .unspecified)
        for device in discoverySession.devices {
            if device.position == position {
                return device
            }
        }
        return nil
    }
    
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
    
    func transmitPhotoData(mediaData: MediaData?) {
        if cameraService.session.connectedPeers.count > 0 {
            captureImage { (data, error) in
                if let error = error {
                    print(error)
                }
                
                guard let photoData = data else {return}
                let mediaData = MediaData()
                mediaData.timestamp = Date()
                mediaData.isVideo = false
                mediaData.mediaData = photoData
                mediaData.thumbnail = photoData
                
                guard let savedData = self.convertToData(timestamp: mediaData.timestamp, mediaData: photoData, thumbnail: photoData, isVideo: false) else {return}
                
                
                do {
                    try self.cameraService.session.send(savedData, toPeers: self.cameraService.session.connectedPeers, with: .reliable)
                    
                    // instantiate realm object and write image data to realm object
                    RealmManager.shareInstance.wrtieToRealm(object: mediaData)
                    
                    DispatchQueue.main.async {
                        self.broadcasterView.thumbnailImageView.image = UIImage(data: photoData)
                        self.broadcasterView.thumbnailImageView.isHidden = false
                    }
                } catch let error as NSError {
                    let ac = UIAlertController(title: "Send error", message: error.localizedDescription, preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(ac, animated: true)
                }
                
            }
        }
    }
    
    func toggleFlash(manager: CameraServiceManager, flashState: String) {
        toggleTorch(flashState: flashState)
    }
    
    func acceptInvitation(manager: CameraServiceManager) {
        
    }
    
    func didStartReceivingData(manager: CameraServiceManager, withName resourceName: String, withProgress progress: Progress) {
        
    }
    
    func didFinishReceivingData(manager: CameraServiceManager, url: NSURL) {
        
    }
}

extension BroadcastViewController: AVCapturePhotoCaptureDelegate {
    // @available(iOS 11.0, *)
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let data = photo.fileDataRepresentation() {
            self.photoCaptureCompletionBlock?(data, nil)
        }else {
            self.photoCaptureCompletionBlock?(nil, CameraError.unknown)
        }
        
    }
}
