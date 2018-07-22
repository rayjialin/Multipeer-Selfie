//
//  FilterModel.swift
//  Multipeer Selfie Share
//
//  Created by ruijia lin on 7/20/18.
//  Copyright © 2018 ruijia lin. All rights reserved.
//

import Foundation

enum FilterType: String{
    case cartoon
    case grayscale
    case colorInversion
    case sharpen
    case sepia
    case solarize
    
    func stringValue() -> String {
        return self.rawValue
    }
}

struct FilterModel {
    let filters = [FilterType.cartoon,
                   FilterType.grayscale,
                   FilterType.colorInversion,
                   FilterType.sharpen,
                   FilterType.sepia,
                   FilterType.solarize]
}
