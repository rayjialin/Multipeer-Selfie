//
//  AVPreviewView.swift
//  Multipeer Selfie Share
//
//  Created by ruijia lin on 7/3/18.
//  Copyright © 2018 ruijia lin. All rights reserved.
//

import AVFoundation
import UIKit

class AVPreviewView: UIView{
    var session: AVCaptureSession? {
        get{
            return (self.layer as! AVCaptureVideoPreviewLayer).session;
        }
        set(session){
            (self.layer as! AVCaptureVideoPreviewLayer).session = session;
        }
    }
    
    class func layerClass() ->AnyClass{
        return AVCaptureVideoPreviewLayer.self;
    }
}
