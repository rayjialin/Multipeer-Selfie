//
//  BrowserViewController+helper.swift
//  Multipeer Selfie Share
//
//  Created by ruijia lin on 7/3/18.
//  Copyright © 2018 ruijia lin. All rights reserved.
//

import Foundation

struct UIMethods {
    
    func tellCameraToTakePhoto(){
        // SEND MESSAGE TO CAMERA TAKE PHOTO, ALONG WITH A BOOLEAN REPRESENTING
        // WHETHER THE CAMERA SHOULD ATTEMPT SENDING THE PHOTO BACK TO THE CONTROLLER
//        cameraService.takePhoto(savePhoto!)
    }
    
    func takePhoto(){
        print("button tapped: take photo")
    }
    
    func flashToggled(state: String){
        switch state {
        case "flashAuto":
            print("handle flash auto")
            break
        case "flashOn":
            print("handle flash on")
            break
        case "flashOff":
            print("handle flash off")
            break
        default:
            break
        }
    }
}
