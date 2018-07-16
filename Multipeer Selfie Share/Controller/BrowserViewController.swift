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
    let photo = Photo()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        browserView.frame = view.frame
        view.addSubview(browserView)
        cameraService.delegate = self
        
        browserView.connectButton.addTarget(self, action: #selector(handleConnect), for: .touchUpInside)
        browserView.takePhotoButton.addTarget(self, action: #selector(handleTakePhoto), for: .touchUpInside)
        browserView.flashButton.addTarget(self, action: #selector(handleFlashToggle), for: .touchUpInside)
        browserView.backButton.addTarget(self, action: #selector(handleBackButtonPressed), for: .touchUpInside)
    }
    
    @objc private func handleBackButtonPressed(){
        dismiss(animated: true, completion: nil)
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
        print("pressed")
        
        if browserView.second < 1 {
            shutter()
        }else {
            if isTimerRunning == false{
                timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: #selector(updateTimer), userInfo: nil, repeats: true)
                isTimerRunning = true
                browserView.takePhotoButton.isEnabled = false
            }
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
    
    func shutter() {
        if cameraService.session.connectedPeers.count > 0 {
            
            guard let shutterString = "shutterPressed".data(using: String.Encoding.utf8) else {return}
            
            do {
                try cameraService.session.send(shutterString, toPeers: cameraService.session.connectedPeers, with: .reliable)
            } catch let error as NSError {
                let ac = UIAlertController(title: "Send error", message: error.localizedDescription, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                present(ac, animated: true)
            }
        }
    }
    
    func flash(flashState: String){
        if cameraService.session.connectedPeers.count > 0 {
            guard let flashModelString = flashState.data(using: String.Encoding.utf8) else {return}
            
            do {
                try cameraService.session.send(flashModelString, toPeers: cameraService.session.connectedPeers, with: .reliable)
            } catch let error as NSError {
                let ac = UIAlertController(title: "Send error", message: error.localizedDescription, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                present(ac, animated: true)
            }
            
        }
    }
    
//    @objc private func viewCapturedPhoto(){
//        guard let photosURL = URL(string:"photos-redirect://") else {return}
//        UIApplication.shared.open(photosURL, options: [:], completionHandler: nil)
//    }
    
    @objc private func updateTimer() {
        if browserView.second > 1{
            browserView.second -= 1
            browserView.timerLabel.text = "\(browserView.second)"
        } else {
            browserView.second = 0
            browserView.timerLabel.isHidden = true
            timer.invalidate()
            shutter()
        }
    }
    
}

