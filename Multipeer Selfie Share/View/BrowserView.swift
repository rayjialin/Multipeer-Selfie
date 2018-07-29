//
//  BrowserView.swift
//  Multipeer Selfie Share
//
//  Created by ruijia lin on 7/3/18.
//  Copyright © 2018 ruijia lin. All rights reserved.
//

import UIKit
import AVFoundation
import SwiftyButton

class BrowserView: BaseView {

    let timePicker = UIPickerView()
    let popover = Popover()
    
    var torchMode: AVCaptureDevice.TorchMode {
        didSet{
            switch torchMode {
            case .auto:
                flashButton.imageView?.image = flashAutoIcon
                break
            case .off:
                flashButton.imageView?.image = flashOffIcon
                break
            case .on:
                flashButton.imageView?.image = flashOnIcon
                break
            }
        }
    }

    var second: Int {
        didSet{
            timerLabel.text = String(second)
            timerLabel.isHidden = false
        }
    }
    
    var lastCapturedPhoto: UIImage? {
        didSet{
            thumbnailImageView.image = lastCapturedPhoto
            thumbnailImageView.isHidden = false
        }
    }
    
    // Take-Photo Button
    let takePhotoButton: PressableButton = {
        let button = PressableButton()
        button.frame.size = CGSize(width: 200, height: 200)
        button.clipsToBounds = true
        button.cornerRadius = 100
        button.shadowHeight = 5
        button.depth = 1
        button.colors = .init(button: flatGreen, shadow: flatGreenDark)
        button.disabledColors = .init(button: flatGray, shadow: flatGrayDark)
        return button
    }()
    
    override init(frame: CGRect) {
        second = 0
        torchMode = AVCaptureDevice.TorchMode.off
        super.init(frame: frame)
        
        setupView()
        timePicker.delegate = self
        timePicker.dataSource = self
        timerButton.addTarget(self, action: #selector(handleSetTimer), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        
        backgroundColor = UIColor.init(complementaryFlatColorOf: flatBlack, withAlpha: 0.9)
        
        [takePhotoButton].forEach {self.addSubview($0)}
        takePhotoButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8).isActive = true
        takePhotoButton.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8).isActive = true
        takePhotoButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        takePhotoButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    }
    
    @objc private func handleSetTimer(){
        // display popover menu to set timer
        let startPoint = CGPoint(x: timerButton.frame.origin.x + timerButton.frame.width / 2, y: headerContainerView.frame.height)
        let aView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width * 0.3, height: self.frame.height / 3))
        
        timePicker.frame = aView.frame
        aView.addSubview(timePicker)
        popover.show(aView, point: startPoint)
    }
}

extension BrowserView: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 60
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        second = row + 1
        popover.dismiss()
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row + 1)"
    }
}
