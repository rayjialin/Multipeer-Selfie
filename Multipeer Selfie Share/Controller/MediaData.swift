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
}
