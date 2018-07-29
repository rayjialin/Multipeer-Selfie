//
//  VideoPlayerViewController.swift
//  Multipeer Selfie Share
//
//  Created by ruijia lin on 7/29/18.
//  Copyright © 2018 ruijia lin. All rights reserved.
//

import Foundation
import AVKit

class VideoPlayerViewController: AVPlayerViewController {
    
//    let videoPlayerView = VideoPlayerView()
    var mediaData: Data?
    var date = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        videoPlayerView.frame = view.frame
//        view.addSubview(videoPlayerView)
        guard let data = mediaData else {return}
        guard let dataString = String.init(data: data, encoding: String.Encoding.utf8) else {return}
        guard let videoURL = URL.init(string: dataString) else {return}
        self.player = AVPlayer(url: videoURL)
        
        self.player?.play()
    }
}

extension VideoPlayerViewController: AVPlayerViewControllerDelegate {
    
}
