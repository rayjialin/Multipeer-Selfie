//
//  CameraServiceManager.swift
//  Multipeer Selfie Share
//
//  Created by ruijia lin on 7/2/18.
//  Copyright © 2018 ruijia lin. All rights reserved.
//

import Foundation
import MultipeerConnectivity

// TO DO: MAKE THIS AN @objc PROTOCOL AND MAKE SOME OF THESE FUNCTIONS OPTIONAL
protocol CameraServiceManagerDelegate: class {
    func connectedDevicesChanged(manager: CameraServiceManager, state: MCSessionState, connectedDevices: [String])
    func transmitPhotoData(mediaData: MediaData?)
    func toggleFlash(manager: CameraServiceManager, flashState: String)
    func acceptInvitation(manager: CameraServiceManager)
    func didStartReceivingData(manager: CameraServiceManager, withName resourceName: String, withProgress progress: Progress)
    func didFinishReceivingData(manager: CameraServiceManager, url: NSURL)
    func switchCameraButtonTapped(manager: CameraServiceManager, switchCameraRequest: String?)
    func updateTimerLabel(timerValue: String?)
}

class CameraServiceManager: NSObject {
    
    var flashState = ""
    let myPeerId =  MCPeerID(displayName: UIDevice.current.name)
    var serviceBroadcaster: MCNearbyServiceAdvertiser
    var serviceBrowser: MCNearbyServiceBrowser
    weak var delegate: CameraServiceManagerDelegate?
    var broadcaster: MCPeerID?
    lazy var session: MCSession = {
        let session = MCSession(peer: myPeerId, securityIdentity: nil, encryptionPreference: MCEncryptionPreference.optional)
        return session
    }()
    
    override init() {
        
        serviceBroadcaster = MCNearbyServiceAdvertiser(peer: myPeerId, discoveryInfo: nil, serviceType: serviceType)
        serviceBrowser = MCNearbyServiceBrowser(peer: myPeerId, serviceType: serviceType)
        super.init()
        session.delegate = self
    }
    
    deinit {
        serviceBroadcaster.stopAdvertisingPeer()
        serviceBrowser.stopBrowsingForPeers()
    }
}

extension CameraServiceManager: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        print("peer \(peerID) didChangeState: \(state.stringValue)")
        delegate?.connectedDevicesChanged(manager: self, state: state, connectedDevices: session.connectedPeers.map({$0.displayName}))
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        print("DidReceiveData: \(data)")
        
        if let unarchivedData = NSKeyedUnarchiver.unarchiveObject(with: data) as? [String: Any] {
            let mediaData = MediaData()
            mediaData.timestamp = unarchivedData["timestamp"] as! Date
            mediaData.isVideo = unarchivedData["isVideo"] as! Bool
            mediaData.mediaData = unarchivedData["mediaData"] as? Data
            mediaData.thumbnail = unarchivedData["thumbnail"] as? Data
            
                // go into browser delegate method
                delegate?.transmitPhotoData(mediaData: mediaData)
            
        }else{
            let dataString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
            
            // Check dataString and act accordingly
            switch dataString {
            case "flashOn":
                delegate?.toggleFlash(manager: self, flashState: "flashOn")
            case "flashOff":
                delegate?.toggleFlash(manager: self, flashState: "flashOff")
            case "flashAuto":
                delegate?.toggleFlash(manager: self, flashState: "flashAuto")
            case "shutterPressed":
                delegate?.transmitPhotoData(mediaData: nil)
            case "switchCameraPressed":
                delegate?.switchCameraButtonTapped(manager: self, switchCameraRequest: "switchCameraPressed")
            default:
                print("receiving error")
            }
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
    }
    
}

extension MCSessionState {
    func stringValue() -> String {
        switch(self) {
        case .notConnected: return "NotConnected"
        case .connecting: return "Connecting"
        case .connected: return "Connected"
        }
    }
}
