//
//  Extensions.swift
//  Multipeer Selfie Share
//
//  Created by ruijia lin on 7/26/18.
//  Copyright © 2018 ruijia lin. All rights reserved.
//

import UIKit

extension NSMutableAttributedString {
    
    func setColorForText(textForAttribute: String, withColor color: UIColor) {
        let range: NSRange = self.mutableString.range(of: textForAttribute, options: .caseInsensitive)
        
        // Swift 4.1 and below
        self.addAttribute(NSAttributedStringKey.foregroundColor, value: color, range: range)
    }
}

extension FileManager {
    func clearTmpDirectory() {
        do {
            let tmpDirURL = FileManager.default.temporaryDirectory
            let tmpDirectory = try contentsOfDirectory(atPath: tmpDirURL.path)
            try tmpDirectory.forEach { file in
                let fileUrl = tmpDirURL.appendingPathComponent(file)
                try removeItem(atPath: fileUrl.path)
            }
        } catch {
            print("Failed to delete data in tmp directory")
        }
    }
}

extension Date {
    static func convertDateToStringLong(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE\nMMMM dd, yyyy"
        
        let currentDateString = dateFormatter.string(from: date)
        return currentDateString
    }
    
    static func convertDatetoStringShort(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "mmddyyyy"
        
        let currentDateString = dateFormatter.string(from: date)
        return currentDateString
    }
}

extension UIView
{
    func addCornerRadiusAnimation(from: CGFloat, to: CGFloat, duration: CFTimeInterval)
    {
        let animation = CABasicAnimation(keyPath:"cornerRadius")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.fromValue = from
        animation.toValue = to
        animation.duration = duration
        layer.add(animation, forKey: "cornerRadius")
        layer.cornerRadius = to
    }
}
