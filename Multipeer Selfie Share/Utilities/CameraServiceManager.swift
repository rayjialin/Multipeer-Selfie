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
protocol CameraServiceManagerDelegate {
    func connectedDevicesChanged(manager: CameraServiceManager, state: MCSessionState, connectedDevices: [String])
    func shutterButtonTapped(manager: CameraServiceManager, image: UIImage?)
    func toggleFlash(manager: CameraServiceManager, flashState: String)
    func acceptInvitation(manager: CameraServiceManager)
    func didStartReceivingData(manager: CameraServiceManager, withName resourceName: String, withProgress progress: Progress)
    func didFinishReceivingData(manager: CameraServiceManager, url: NSURL)
}

class CameraServiceManager: NSObject {
    
    var flashState = ""
    var localUrl: URL?
    let myPeerId =  MCPeerID(displayName: UIDevice.current.name)
    var serviceBroadcaster: MCNearbyServiceAdvertiser
    var serviceBrowser: MCNearbyServiceBrowser
    let serviceType = "selfie-party"
    var delegate: CameraServiceManagerDelegate?    
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
    
    func takePhoto(sendPhoto: Bool) {
        do {
            var boolString = ""
            if (sendPhoto) {
                boolString = "true"
            } else {
                boolString = "false"
            }
            
            guard let data = boolString.data(using: .utf8) else {return}
            try session.send(data, toPeers: session.connectedPeers, with: .reliable)
        }
        catch {
            print("SOMETHING WENT WRONG IN CameraServiceManager.takePhoto()")
        }
    }
}


//extension CameraServiceManager: MCNearbyServiceAdvertiserDelegate {
//    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
//
//        print("DidReceiveInvitationFromPeer: \(peerID)")
//        invitationHandler(true, session)
//    }
//
//    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
//        print("DidNotStartAdvertisingForPeers")
//    }
//
//}
//extension CameraServiceManager: MCNearbyServiceBrowserDelegate {
//    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
//
//        print("FoundPeer: \(peerID)")
//
//        browser.invitePeer(peerID, to: session, withContext: nil, timeout: 10)
//    }
//
//    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
//        print("LostPeer: \(peerID)")
//    }


//}

//
// @class MCSession
//   @abstract
//      A MCSession facilitates communication among all peers in a multipeer
//      session.
//
//   @discussion
//      To start a multipeer session with remote peers, a MCPeerID that
//      represents the local peer needs to be supplied to the init method.
//
//      Once a peer is added to the session on both sides, the delegate
//      callback -session:peer:didChangeState: will be called with
//      MCSessionStateConnected state for the remote peer.
//
//      Data messages can be sent to a connected peer with the -sendData:
//      toPeers:withMode:error: method.
//
//      The receiver of data messages will receive a delegate callback
//      -session:didReceiveData:fromPeer:.
//
//      Resources referenced by NSURL (e.g. a file) can be sent to a connected
//      peer with the -sendResourceAtURL:toPeer:withTimeout:completionHandler:
//      method. The completionHandler will be called when the resource is fully
//      received by the remote peer, or if an error occurred during
//      transmission. The receiver of data messages will receive a delegate
//      callbacks -session:didStartReceivingResourceWithName:fromPeer:
//      withProgress: when it starts receiving the resource and -session:
//      didFinishReceivingResourceWithName:fromPeer:atURL:withError:
//      when the resource has been fully received.
//
//      A byte stream can be sent to a connected peer with the
//      -startStreamWithName:toPeer:error: method. On success, an
//      NSOutputStream  object is returned, and can be used to send bytes to
//      the remote peer once the stream is properly set up. The receiver of the
//      byte stream will receive a delegate callback -session:didReceiveStream:
//      withName:fromPeer:
//
//      Delegate calls occur on a private serial queue. If your app needs to
//      perform an action on a particular run loop or operation queue, its
//      delegate method should explicitly dispatch or schedule that work.
//

extension CameraServiceManager: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        print("peer \(peerID) didChangeState: \(state.stringValue)")
        delegate?.connectedDevicesChanged(manager: self, state: state, connectedDevices: session.connectedPeers.map({$0.displayName}))
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        print("DidReceiveData: \(data)")
        
        if let image = UIImage(data: data) {
            delegate?.shutterButtonTapped(manager: self, image: image)
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
                delegate?.shutterButtonTapped(manager: self, image: nil)
            case "photoCaptured":
                delegate?.shutterButtonTapped(manager: self, image: nil)
            default:
                print("receiving error")
            }
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        //        delegate?.didStartReceivingData(manager: self, withName: resourceName, withProgress: progress)
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
        //        let downloadPath = NSSearchPathForDirectoriesInDomains(.downloadsDirectory, .userDomainMask, true)[0]
        //        let photoDestinationURL = NSURL.fileURL(withPath: downloadPath + UUID().uuidString + ".jpg")
        //
        //        do {
        //            guard let localURL = localURL else {return}
        //            let fileHandle: FileHandle = try FileHandle(forReadingFrom: localURL)
        //            let data = fileHandle.readDataToEndOfFile()
        //            guard let image = UIImage(data: data) else {return}
        //            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        //            delegate?.didFinishReceivingData(manager: self, url: photoDestinationURL as NSURL)
        //        }
        //        catch{
        //            print("PROBLEM IN CameraServiceManager extension > didFinishReceivingResourceWithName")
        //        }
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
