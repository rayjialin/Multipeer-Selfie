//
//  UIElementState.swift
//  Multipeer Selfie Share
//
//  Created by ruijia lin on 7/3/18.
//  Copyright © 2018 ruijia lin. All rights reserved.
//

import Foundation

enum flashState: String {
    case flashOff
    case flashOn
    case flashAuto
    
    func strValue() -> String {
        return self.rawValue
    }
    
}
