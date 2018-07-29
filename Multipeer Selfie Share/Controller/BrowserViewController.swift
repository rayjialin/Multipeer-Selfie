//
//  BrowserViewController.swift
//  Multipeer Selfie Share
//
//  Created by ruijia lin on 7/2/18.
//  Copyright © 2018 ruijia lin. All rights reserved.
//
//  This class is hanlding devices which are registered to receive captured photos from Broadcasting devices

import UIKit
import MultipeerConnectivity

class BrowserViewController: UIViewController {
    
    let cameraService = CameraServiceManager()
    var mcAdvertiserAssistant: MCAdvertiserAssistant!
    var savePhoto: Bool?
    var isConnected: Bool?
    let browserView = BrowserView()
    var capturedImageFrame = CGRect()
    var timer = Timer()
    var isTimerRunning = false
    var isRecording = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let medias = RealmManager.shareInstance.readFromRealmWith(keyPath: realmTimestampKeyPath, isAscending: false)
        guard let media = medias.first?.mediaData else {return}
        browserView.lastCapturedPhoto = UIImage(data: media)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        browserView.frame = view.frame
        view.addSubview(browserView)
        cameraService.delegate = self
        
        browserView.connectButton.addTarget(self, action: #selector(handleConnect), for: .touchUpInside)
        browserView.takePhotoButton.addTarget(self, action: #selector(handleTakePhoto), for: .touchUpInside)
        browserView.flashButton.addTarget(self, action: #selector(handleFlashToggle), for: .touchUpInside)
        browserView.backButton.addTarget(self, action: #selector(handleBackButtonPressed), for: .touchUpInside)
        browserView.switchCameraButton.addTarget(self, action: #selector(handleCameraSwitch), for: .touchUpInside)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        browserView.thumbnailImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc private func handleBackButtonPressed(){
        dismiss(animated: true, completion: nil)
        cameraService.serviceBrowser.stopBrowsingForPeers()
        cameraService.session.disconnect()
    }
    
    
    func joinSession() {
        let mcBrowser = MCBrowserViewController(serviceType: serviceType, session: cameraService.session)
        mcBrowser.delegate = self
        present(mcBrowser, animated: true)
    }
    
    @objc private func handleConnect(){
        joinSession()
    }
    
    @objc private func handleTakePhoto(){
        
        if browserView.second < 1 {
            shutter()
        }else {
            if isTimerRunning == false{
                timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: #selector(updateTimer), userInfo: nil, repeats: true)
                isTimerRunning = true
            }
        }
    }
    
    @objc private func handleFlashToggle(sender: Any){
        guard let flashButton = sender as? UIButton else {return}
        
        switch flashButton.currentImage {
        case flashAutoIcon:
            flashButton.setImage(flashOnIcon, for: .normal)
            cameraService.flashState = flashState.flashOn.strValue()
        case flashOnIcon:
            flashButton.setImage(flashOffIcon, for: .normal)
            cameraService.flashState = flashState.flashOff.strValue()
        case flashOffIcon:
            flashButton.setImage(flashAutoIcon, for: .normal)
            cameraService.flashState = flashState.flashAuto.strValue()
            break
        default:
            flashButton.setImage(flashAutoIcon, for: .normal)
            cameraService.flashState = flashState.flashAuto.strValue()
        }
        
        flash(flashState: cameraService.flashState)
    }
    
    @objc private func imageTapped(sender: UITapGestureRecognizer) {
        guard let _ = sender.view as? UIImageView else {return}
        performSegue(withIdentifier: segueToPhotosFromRemote, sender: self)
    }
    
    @objc private func handleCameraSwitch(){
        guard let switchCameraString = "switchCameraPressed".data(using: String.Encoding.utf8) else {return}
        prepareSendRequest(data: switchCameraString)
    }
    
    func shutter() {
        guard let shutterString = "shutterPressed".data(using: String.Encoding.utf8) else {return}
        prepareSendRequest(data: shutterString)
    }
    
    func flash(flashState: String){
        guard let flashModelString = flashState.data(using: String.Encoding.utf8) else {return}
        prepareSendRequest(data: flashModelString)
    }
    
    private func prepareSendRequest(data: Data) {
        if cameraService.session.connectedPeers.count > 0 {
            
            // disble shutter button and start animation progress view
            if data == "shutterPressed".data(using: String.Encoding.utf8) {
                browserView.takePhotoButton.isEnabled = false
                browserView.progressBarView.startAnimating()
                browserView.thumbnailImageView.isHidden = true
            }
            
            do {
                try cameraService.session.send(data, toPeers: cameraService.session.connectedPeers, with: .reliable)
            } catch let error as NSError {
                let ac = UIAlertController(title: "Send error", message: error.localizedDescription, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                present(ac, animated: true)
            }
        }
    }
    
    @objc private func updateTimer() {
        if browserView.second > 1{
            browserView.takePhotoButton.isEnabled = false
            browserView.second -= 1
            browserView.timerLabel.text = "\(browserView.second)"
        } else {
            browserView.second = 0
            browserView.timerLabel.isHidden = true
            timer.invalidate()
            shutter()
            browserView.takePhotoButton.isEnabled = true
        }
    }
    
    override func viewWillLayoutSubviews() {
        browserView.takePhotoButton.center = CGPoint(x: view.frame.width / 2, y: view.frame.height / 2)
        browserView.takePhotoButton.layer.cornerRadius = browserView.takePhotoButton.frame.width / 2
        browserView.progressBarView.frame = browserView.thumbnailImageView.frame
    }
    
}

