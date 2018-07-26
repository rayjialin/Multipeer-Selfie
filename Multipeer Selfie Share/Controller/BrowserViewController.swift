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
import RealmSwift

class BrowserViewController: UIViewController {
    
    let cameraService = CameraServiceManager()
    var mcAdvertiserAssistant: MCAdvertiserAssistant!
    var savePhoto: Bool?
    var isConnected: Bool?
    let browserView = BrowserView()
    var capturedImageFrame = CGRect()
    var timer = Timer()
    var isTimerRunning = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        do {
            let realm = try Realm()
            let medias = realm.objects(MediaData.self).sorted(byKeyPath: "timestamp", ascending: false)
            guard let media = medias.first?.mediaData else {return}
            browserView.lastCapturedPhoto = UIImage(data: media)
        } catch {
            print("failed to create realm object")
        }
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
        browserView.captureModeSegmentedControl.addTarget(self, action: #selector(handleSegmentedControlChanged), for: .valueChanged)
    }
    
    @objc private func handleBackButtonPressed(){
        dismiss(animated: true, completion: nil)
        cameraService.serviceBrowser.stopBrowsingForPeers()
        cameraService.session.disconnect()
    }
    
    
    func joinSession() {
        let mcBrowser = MCBrowserViewController(serviceType: "selfie-party", session: cameraService.session)
        mcBrowser.delegate = self
        present(mcBrowser, animated: true)
    }
    
    @objc private func handleConnect(){
        joinSession()
    }
    
    @objc private func handleTakePhoto(){
        
        switch browserView.captureModeSegmentedControl.selectedSegmentIndex {
        case 0: // photo mode
            if browserView.second < 1 {
                shutter()
            }else {
                if isTimerRunning == false{
                    timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: #selector(updateTimer), userInfo: nil, repeats: true)
                    isTimerRunning = true
                }
            }
        
        case 1: // video mode
            
            break
        default:
            print("pressed button and do nothing")
        }
 
    }
    
    @objc private func handleFlashToggle(sender: Any){
        guard let flashButton = sender as? UIButton else {return}
        
        switch flashButton.currentImage {
        case #imageLiteral(resourceName: "flashAutoIcon"):
            flashButton.setImage(#imageLiteral(resourceName: "flashOnIcon"), for: .normal)
            cameraService.flashState = flashState.flashOn.strValue()
            break
        case #imageLiteral(resourceName: "flashOnIcon"):
            flashButton.setImage(#imageLiteral(resourceName: "flashOffIcon"), for: .normal)
            cameraService.flashState = flashState.flashOff.strValue()
            break
        case #imageLiteral(resourceName: "flashOffIcon"):
            flashButton.setImage(#imageLiteral(resourceName: "flashAutoIcon"), for: .normal)
            cameraService.flashState = flashState.flashAuto.strValue()
            break
        default:
            flashButton.setImage(#imageLiteral(resourceName: "flashAutoIcon"), for: .normal)
            cameraService.flashState = flashState.flashAuto.strValue()
        }
        
        flash(flashState: cameraService.flashState)
    }
    
    @objc private func imageTapped(sender: UITapGestureRecognizer) {
        guard let _ = sender.view as? UIImageView else {return}
        performSegue(withIdentifier: "segueToPhotosFromRemote", sender: self)
    }
    
    @objc private func handleCameraSwitch(){
        guard let switchCameraString = "switchCameraPressed".data(using: String.Encoding.utf8) else {return}
        prepareSendRequest(data: switchCameraString)
    }
    
    @objc private func handleSegmentedControlChanged(sender: UISegmentedControl) {
        UIView.animate(withDuration: 0.3) {
            let captureModeSegmentedControl = self.browserView.captureModeSegmentedControl
            self.browserView.ScButtomBar.frame.origin.x = captureModeSegmentedControl.frame.width / CGFloat(
                captureModeSegmentedControl.numberOfSegments) * CGFloat(captureModeSegmentedControl.selectedSegmentIndex)
        }
        
        switch sender.selectedSegmentIndex {
        case 0: // photo mode
            handlePhotoMode()
        case 1: // video mode
            handleVideoMode()
        default:
            print("default mode, doing nothing")
        }
    }
    
    private func handlePhotoMode() {
        UIView.animate(withDuration: 0.5) {
            self.browserView.takePhotoButton.depth = 1
            self.browserView.takePhotoButton.shadowHeight = 5
        }
    }
    
    private func handleVideoMode() {
        UIView.animate(withDuration: 0.5) {
            self.browserView.takePhotoButton.depth = 0
            self.browserView.takePhotoButton.shadowHeight = 0
        }
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

