//
//  BroadcastViewController.swift
//  Multipeer Selfie Share
//
//  Created by ruijia lin on 7/2/18.
//  Copyright © 2018 ruijia lin. All rights reserved.
//
//  The class is handling device which is registered to act as camera and holds information about all the connect discovery devices

import UIKit
import AVFoundation
import MultipeerConnectivity

enum CameraError: Swift.Error {
    case captureSessionAlreadyRunning
    case captureSessionIsMissing
    case inputsAreInvalid
    case invalidOperation
    case noCamerasAvailable
    case unknown
}

public enum CameraPosition {
    case front
    case rear
}

class BroadcastViewController: UIViewController {
    
    var cameraService = CameraServiceManager()
    var captureSession: AVCaptureSession?
    var frontCamera: AVCaptureDevice?
    var rearCamera: AVCaptureDevice?
    var currentCameraPosition: CameraPosition?
    var frontCameraInput: AVCaptureDeviceInput?
    var rearCameraInput: AVCaptureDeviceInput?
    var photoOutput: AVCapturePhotoOutput?
    var previewLayer: AVCaptureVideoPreviewLayer?
    var mcAdvertiserAssistant: MCAdvertiserAssistant!
    var photoCaptureCompletionBlock: ((Data?, Error?) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        startHosting()
        
        func configureCamera() {
            prepare {(error) in
                if let error = error {
                    print(error)
                }
                try? self.displayPreview(on: self.view)
            }
        }

        configureCamera()
        cameraService.delegate = self
    }
    
    func startHosting() {
        mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "selfie-party", discoveryInfo: nil, session: cameraService.session)
        mcAdvertiserAssistant.start()
    }
    
    func toggleTorch(flashState: String) {
        guard let device = AVCaptureDevice.default(for: AVMediaType.video)
            else {return}
        
        if device.hasTorch {
            do {
                try device.lockForConfiguration()
                
                if flashState == "flashOff" {
                    device.torchMode = .off
                } else if flashState == "flashOn" {
                    device.torchMode = .on
                } else if flashState == "flashAuto" {
                    device.torchMode = .auto
                } else {
                    device.torchMode = .off
                }
                device.unlockForConfiguration()
            } catch {
                print("Torch could not be used")
            }
        } else {
            print("Torch is not available")
        }
    }
    
    func prepare(completionHandler: @escaping (Error?) -> Void) {
        func createCaptureSession() {
            captureSession = AVCaptureSession()
        }
        
        func configureCaptureDevices() throws {
            let session = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .unspecified)
            let cameras = session.devices.compactMap {$0}
            
            guard !cameras.isEmpty else { throw CameraError.noCamerasAvailable }
        
            for camera in cameras {
                if camera.position == .front {
                    frontCamera = camera
                }
                
                if camera.position == .back {
                    rearCamera = camera
                    try camera.lockForConfiguration()
                    camera.focusMode = .continuousAutoFocus
                    camera.unlockForConfiguration()
                }
            }
        }
        
        func configureDeviceInputs() throws {
            guard let captureSession = captureSession else { throw CameraError.captureSessionIsMissing }
            
            if let rearCamera = rearCamera {
                rearCameraInput = try AVCaptureDeviceInput(device: rearCamera)
                
                if captureSession.canAddInput(rearCameraInput!) {
                    captureSession.addInput(rearCameraInput!)
                }
                self.currentCameraPosition = .rear
            }
                
            else if let frontCamera = frontCamera {
                self.frontCameraInput = try AVCaptureDeviceInput(device: frontCamera)
                
                if captureSession.canAddInput(frontCameraInput!) {
                    captureSession.addInput(frontCameraInput!)
                }else {
                    throw CameraError.inputsAreInvalid
                }
                self.currentCameraPosition = .front
            }
                
            else { throw CameraError.noCamerasAvailable }
        }
        
        func configurePhotoOutput() throws {
            guard let captureSession = captureSession else { throw CameraError.captureSessionIsMissing }
            
            photoOutput = AVCapturePhotoOutput()
            photoOutput?.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey : AVVideoCodecType.jpeg])], completionHandler: nil)
            
            if captureSession.canAddOutput(photoOutput!) { captureSession.addOutput(photoOutput!) }
            
            captureSession.startRunning()
        }
        
        DispatchQueue(label: "prepare").async {
            do {
                createCaptureSession()
                try configureCaptureDevices()
                try configureDeviceInputs()
                try configurePhotoOutput()
            } catch {
                DispatchQueue.main.async {
                    completionHandler(error)
                }
                return
            }
            
            DispatchQueue.main.async {
                completionHandler(nil)
            }
        }
    }
    
    func displayPreview(on view: UIView) throws {
        guard let captureSession = captureSession, captureSession.isRunning else { throw CameraError.captureSessionIsMissing }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        previewLayer?.connection?.videoOrientation = .portrait
        
        view.layer.insertSublayer(previewLayer!, at: 0)
        previewLayer?.frame = view.frame
    }
    
    func captureImage(completion: @escaping (Data?, Error?) -> Void) {
        guard let captureSession = captureSession, captureSession.isRunning else { completion(nil, CameraError.captureSessionIsMissing); return }
        
        let settings = AVCapturePhotoSettings()
        self.photoOutput?.capturePhoto(with: settings, delegate: self)
        self.photoCaptureCompletionBlock = completion
    }
    
}