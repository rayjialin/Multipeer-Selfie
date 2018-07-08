//
//  BroadcastViewController+delegate.swift
//  Multipeer Selfie Share
//
//  Created by ruijia lin on 7/4/18.
//  Copyright © 2018 ruijia lin. All rights reserved.
//

import AVFoundation
import MultipeerConnectivity

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

    func shutterButtonTapped(manager: CameraServiceManager, image: UIImage?) {
        if cameraService.session.connectedPeers.count > 0 {
            captureImage { (data, error) in
                if let error = error {
                    print(error)
                }
                
                guard let photoData = data else {return}
                
                do {
                    try self.cameraService.session.send(photoData, toPeers: self.cameraService.session.connectedPeers, with: .reliable)
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
    public func photoOutput(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?,
                        resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Swift.Error?) {
        if let error = error { self.photoCaptureCompletionBlock?(nil, error) }
            
        else if let buffer = photoSampleBuffer, let data = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: buffer, previewPhotoSampleBuffer: nil) {
            self.photoCaptureCompletionBlock?(data, nil)
        }
        else {
            self.photoCaptureCompletionBlock?(nil, CameraError.unknown)
        }
    }
}
