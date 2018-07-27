//
//  MediaDataModel.swift
//  Multipeer Selfie Share
//
//  Created by ruijia lin on 7/15/18.
//  Copyright © 2018 ruijia lin. All rights reserved.
//

import Foundation
import RealmSwift

class MediaData: Object {
    
    @objc dynamic var timestamp: Date? = nil
    @objc dynamic var mediaData: Data? = nil
    @objc dynamic var thumbnail: Data? = nil
    @objc dynamic var isVideo: Bool = false

    
//    enum DataEnum: String{
//        case timestamp
//        case mediaData
//        case thumbnail
//        case isVideo
//    }
}

//    enum CodingKeys: String, CodingKey {
//        case timestamp
//        case mediaData
//        case thumbnail
//        case isVideo
//    }

//struct MediaStruct {
//    var timestamp: Date
//    var mediaData: Data
//    var thumbnail: Data
//    var isVideo: Bool
//
//    enum CodingKeys: String, CodingKey {
//        case timestamp
//        case mediaData
//        case thumbnail
//        case isVideo
//    }
//}
//
//extension MediaStruct: Encodable {
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(timestamp, forKey: .timestamp)
//        try container.encode(mediaData, forKey: .mediaData)
//        try container.encode(thumbnail, forKey: .thumbnail)
//        try container.encode(isVideo, forKey: .isVideo)
//    }
//}
//
//extension MediaStruct: Decodable{
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        timestamp = try values.decode(Date.self, forKey: .timestamp)
//        mediaData = try values.decode(Data.self, forKey: .mediaData)
//        thumbnail = try values.decode(Data.self, forKey: .thumbnail)
//        isVideo = try values.decode(Bool.self, forKey: .isVideo)
//    }
//}
