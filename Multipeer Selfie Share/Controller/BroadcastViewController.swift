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
import RealmSwift
import NVActivityIndicatorView
import AVKit

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
    var dataOutput: AVCaptureVideoDataOutput?
    var audioOutput: AVCaptureAudioDataOutput?
    var movieOutput: AVCaptureMovieFileOutput?
    var assetWriter: AVAssetWriter?
    var assetWriterInput: AVAssetWriterInput?
    var pixelBufferAdaptor: AVAssetWriterInputPixelBufferAdaptor?
    var previewLayer: AVCaptureVideoPreviewLayer?
    var mcAdvertiserAssistant: MCAdvertiserAssistant!
    var photoCaptureCompletionBlock: ((Data?, Error?) -> Void)?
    let broadcasterView = BroadcasterView()
    
    var frameNumber: Int64 = 0 {
        didSet{
            broadcasterView.videoLengthLabel.text = String(frameNumber)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        captureSession?.startRunning()
        
        do {
            let realm = try Realm()
            let photos = realm.objects(Photo.self).sorted(byKeyPath: "timestamp", ascending: false)
            guard let photo = photos.first?.photoData else {return}
            broadcasterView.lastCapturedPhoto = UIImage(data: photo)
        } catch {
            print("failed to create realm object")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        // view for progress bar
        let activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        view.addSubview(activityIndicatorView)
        
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
        broadcasterView.frame = view.frame
        view.addSubview(broadcasterView)
        
        
        broadcasterView.backButton.addTarget(self, action: #selector(handleBackButtonPressed), for: .touchUpInside)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        broadcasterView.thumbnailImageView.addGestureRecognizer(tapGestureRecognizer)
        
//        broadcasterView.recordingStartButton.addTarget(self, action: #selector(handleStartRecording), for: .touchUpInside)
//        broadcasterView.recordingEndButton.addTarget(self, action: #selector(handleEndRecording), for: .touchUpInside)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        captureSession?.stopRunning()
    }
    
    @objc private func handleBackButtonPressed(){
        dismiss(animated: true, completion: nil)
        cameraService.serviceBroadcaster.stopAdvertisingPeer()
        cameraService.session.disconnect()
        captureSession?.stopRunning()
    }
    
    @objc private func imageTapped(sender: UITapGestureRecognizer) {
        guard let _ = sender.view as? UIImageView else {return}
        performSegue(withIdentifier: "segueToPhotoFromCamera", sender: self)
    }
    
    func startHosting() {
        mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "selfie-party", discoveryInfo: nil, session: cameraService.session)
        mcAdvertiserAssistant.start()
    }
    
    func toggleTorch(flashState: String) {
        guard let device = AVCaptureDevice.default(for: AVMediaType.video)
            else {return}
        let deviceSettings = AVCapturePhotoSettings()
        
        if device.hasTorch {
            do {
                try device.lockForConfiguration()
                
                if flashState == "flashOff" {
                    deviceSettings.flashMode = .off
                    DispatchQueue.main.async {
                        self.broadcasterView.flashButton.setImage(#imageLiteral(resourceName: "flashOffIcon"), for: .normal)
                    }
                } else if flashState == "flashOn" {
                    deviceSettings.flashMode = .on
                    DispatchQueue.main.async {
                        self.broadcasterView.flashButton.setImage(#imageLiteral(resourceName: "flashOnIcon"), for: .normal)
                    }
                } else if flashState == "flashAuto" {
                    deviceSettings.flashMode = .auto
                    DispatchQueue.main.async {
                        self.broadcasterView.flashButton.setImage(#imageLiteral(resourceName: "flashAutoIcon"), for: .normal)
                    }
                } else {
                    deviceSettings.flashMode = .off
                    DispatchQueue.main.async {
                        self.broadcasterView.flashButton.setImage(#imageLiteral(resourceName: "flashOffIcon"), for: .normal)
                    }
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
            dataOutput = AVCaptureVideoDataOutput()
            audioOutput = AVCaptureAudioDataOutput()
            movieOutput = AVCaptureMovieFileOutput()
            
            guard let photoOutput = photoOutput else {return}
//            guard let dataOutput = dataOutput else {return}
//            guard let audioOutput = audioOutput else {return}
//            guard let movieOutput = movieOutput else {return}
            
//            dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue.global())
//            dataOutput.recommendedVideoSettings(forVideoCodecType: .h264, assetWriterOutputFileType: .mp4)
////            dataOutput.videoSettings = [(kCVPixelBufferPixelFormatTypeKey as NSString): NSNumber(value: kCVPixelFormatType_420YpCbCr8PlanarFullRange as UInt32)] as [String : Any]
//            assetWriterInput = AVAssetWriterInput(mediaType: AVMediaType.video, outputSettings: [AVVideoWidthKey: 640, AVVideoHeightKey: 480, AVVideoCodecKey: AVVideoCodecType.h264])
//            guard let assetWriterInput = assetWriterInput else {return}
//            pixelBufferAdaptor = AVAssetWriterInputPixelBufferAdaptor(assetWriterInput: assetWriterInput, sourcePixelBufferAttributes: [kCVPixelBufferPixelFormatTypeKey as String : Int(kCVPixelFormatType_32BGRA)])
//
//            do {
//                guard let url = applicationDocumentsDirectory()?.appendingPathComponent("video").appendingPathExtension("mp4") else {return}
//                assetWriter = try AVAssetWriter(url: url, fileType: .mp4)
//                guard let assetWriter = assetWriter else {return}
//                guard assetWriter.canAdd(assetWriterInput) else {return}
//                assetWriter.add(assetWriterInput)
//                assetWriterInput.expectsMediaDataInRealTime = true
//
//            }catch {
//                print("failed to create asset writer")
//            }
//
//            dataOutput.alwaysDiscardsLateVideoFrames = true
            
//            audioOutput.recommendedAudioSettingsForAssetWriter(writingTo: .aiff)
            photoOutput.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey : AVVideoCodecType.jpeg])], completionHandler: nil)
            
//            movieOutput.setOutputSettings(<#T##outputSettings: [String : Any]?##[String : Any]?#>, for: <#T##AVCaptureConnection#>)
            
            if captureSession.canAddOutput(photoOutput) {
                captureSession.addOutput(photoOutput)
            }
            
//            if captureSession.canAddOutput(movieOutput) {
//                captureSession.addOutput(movieOutput)
//            }
//            if captureSession.canAddOutput(dataOutput) {
//                captureSession.addOutput(dataOutput)
//            }
//
//            if captureSession.canAddOutput(audioOutput) {
//                captureSession.addOutput(audioOutput)
//            }
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
    
//    @objc private func handleStartRecording() {
//        guard let assetWriter = assetWriter else {return}
//        assetWriter.startSession(atSourceTime: CMTime(value: frameNumber, timescale: 25))
//        assetWriter.startWriting()
//        assetWriter.startSession(atSourceTime: kCMTimeZero)
//        
//        guard let captureSession = captureSession else {return}
////        if !captureSession.isRunning {
//            captureSession.startRunning()
////        }
//    }
    
//    @objc private func handleEndRecording() {
//        guard let assetWriter = assetWriter else {return}
//        assetWriter.endSession(atSourceTime: CMTime(value: frameNumber, timescale: 25))
//        assetWriter.finishWriting {
//            if assetWriter.status == AVAssetWriterStatus.failed {
//                print(assetWriter.error)
//            }else {
//                print(assetWriter.outputURL)
//                print(assetWriter.outputFileType)
//            }
//        }
//    }
    
    private func applicationDocumentsDirectory() -> URL? {
//        return FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).last
        let directory = NSTemporaryDirectory() as NSString
        if directory != "" {
            let path = directory.appendingPathComponent(NSUUID().uuidString + "mp4")
            return URL(fileURLWithPath: path)
        }
        return nil
    }
}
