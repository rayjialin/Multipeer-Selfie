//
//  Constants.swift
//  Multipeer Selfie Share
//
//  Created by ruijia lin on 7/26/18.
//  Copyright © 2018 ruijia lin. All rights reserved.
//

import UIKit
import Chameleon

// String
let filterCell = "filterCell"
let mediaId = "mediaId"
let appName = "MultiPeer Selfie"
let gillSansFont = "GillSans"
let dinCondensedBold = "DINCondensed-Bold"
let appDescription = "All of the devices should be on the same WIFI or have bluetooth enabled to be able to detect each other"
let selectRoleText = "Select Your Role"
let segmentedControlPhoto = "PHOTO"
let segmentedControlVideo = "VIDEO"
let realmTimestampKeyPath = "timestamp"
let realmThumbnailKeyPath = "thumbnail"
let realmMediaDataKeyPath = "mediaData"
let realmIsVideoKeyPath = "isVideo"
let serviceType = "multiPeerSelfie"
let m4vFileExtension = ".m4v"
let tmpPath = NSTemporaryDirectory()
let uuid = NSUUID().uuidString
let tmpPathUrl = URL(fileURLWithPath: tmpPath + uuid + m4vFileExtension)
let tmpPathUrlCompressed = URL(fileURLWithPath: tmpPath + "MPSelfie_" + uuid + m4vFileExtension)
let filterOptions = ["Cartoon",
                     "Grayscale",
                     "Color Inversion",
                     "Sharpen",
                     "Sepia",
                     "Solarize"]

// Numbers
let yOffsetSpeed: CGFloat = 150.0
let xOffsetSpeed: CGFloat = 100.0

// Color
let flatWhiteDark = UIColor.flatWhiteColorDark()!
let flatGreenDark = UIColor.flatGreenColorDark()!
let flatGreen = UIColor.flatGreen()!
let lightGray = UIColor.lightGray
let flatGrayDark = UIColor.flatGrayColorDark()!
let flatGray = UIColor.flatGray()!
let flatBlack = UIColor.flatBlack()!
let flatWhite = UIColor.flatWhite()!

// Image Assets
let remoteRoleIcon = #imageLiteral(resourceName: "remoteIcon")
let cameraRoleIcon = #imageLiteral(resourceName: "cameraIcon")
let backButtonIcon = #imageLiteral(resourceName: "backIcon")
let flashOnIcon = #imageLiteral(resourceName: "flashOnIcon")
let flashOffIcon = #imageLiteral(resourceName: "flashOffIcon")
let flashAutoIcon = #imageLiteral(resourceName: "flashAutoIcon")
let connectionIcon = #imageLiteral(resourceName: "connectIcon")
let timerIcon = #imageLiteral(resourceName: "timerIcon")
let switchCameraIcon = #imageLiteral(resourceName: "switchCameraIcon")
let deleteIcon = #imageLiteral(resourceName: "deleteIcon")
let filterIcon = #imageLiteral(resourceName: "filterIcon")
let hdrIcon = #imageLiteral(resourceName: "HdrIcon")
let settingIcon = #imageLiteral(resourceName: "settingIcon")
let sortIcon = #imageLiteral(resourceName: "sortIcon")
let homeBackgoundImage = #imageLiteral(resourceName: "homeBg")

// Segue Identifiers
let segueToBroadcast = "segueToBroadcast"
let segueToBrowse = "segueToBrowse"
let segueToPhotosFromCamera = "segueToPhotosFromCamera"
let segueToSetting = "segueToSetting"
let segueToDetails = "segueToDetails"
let segueToPhotosFromRemote = "segueToPhotosFromRemote"
let segueToVideoPlayer = "segueToVideoPlayer"


