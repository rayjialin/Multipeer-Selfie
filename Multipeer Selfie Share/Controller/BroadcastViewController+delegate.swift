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

    func shutterButtonTapped(manager: CameraServiceManager, data: Data?) {
        if cameraService.session.connectedPeers.count > 0 {
            captureImage { (data, error) in
                if let error = error {
                    print(error)
                }
                
                guard let photoData = data else {return}
                
                do {
                    try self.cameraService.session.send(photoData, toPeers: self.cameraService.session.connectedPeers, with: .reliable)
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
    
// before iOS 10.0 *
//    public func photoOutput(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Swift.Error?) {
//        if let error = error { self.photoCaptureCompletionBlock?(nil, error) }
//
//        else if let buffer = photoSampleBuffer, let data = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: buffer, previewPhotoSampleBuffer: nil) {
//            self.photoCaptureCompletionBlock?(data, nil)
//        }
//        else {
//            self.photoCaptureCompletionBlock?(nil, CameraError.unknown)
//        }
//    }
}

extension BroadcastViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer), let assetWriterInput = assetWriterInput, let pixelBufferAdaptor = pixelBufferAdaptor else {return}
        if assetWriterInput.isReadyForMoreMediaData {
            pixelBufferAdaptor.append(imageBuffer, withPresentationTime: CMTime(value: frameNumber, timescale: 25))
        }
        
        frameNumber += 1
    }
}

//extension BroadcastViewController: AVCaptureFileOutputRecordingDelegate {
//    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
//        if error != nil {
//            print("Error recording movie: \(error!.localizedDescription)")
//        }else {
//
//        }
//    }
//}
