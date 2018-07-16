//
//  BrowserView.swift
//  Multipeer Selfie Share
//
//  Created by ruijia lin on 7/3/18.
//  Copyright © 2018 ruijia lin. All rights reserved.
//

import UIKit
import AVFoundation
import Chameleon

class BrowserView: BaseView {

    let timePicker = UIPickerView()
    let popover = Popover()
    
    var torchMode: AVCaptureDevice.TorchMode {
        didSet{
            switch torchMode {
            case .auto:
                flashButton.imageView?.image = #imageLiteral(resourceName: "flashAutoIcon")
                break
            case .off:
                flashButton.imageView?.image = #imageLiteral(resourceName: "flashOffIcon")
                break
            case .on:
                flashButton.imageView?.image = #imageLiteral(resourceName: "flashOnIcon")
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
    
    @objc dynamic var fileTransferProgress : Progress!

    // Take-Photo Button
    let takePhotoButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.showsTouchWhenHighlighted = true
        button.setImage(#imageLiteral(resourceName: "circle"), for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        second = 0
        torchMode = AVCaptureDevice.TorchMode.off
        super.init(frame: frame)
        
        setupView()
        setupConstraint()
        
        timePicker.delegate = self
        timePicker.dataSource = self
        
        timerButton.addTarget(self, action: #selector(handleSetTimer), for: .touchUpInside)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        
        backgroundColor = UIColor(white: 0.4, alpha: 0.4)
//        [takePhotoButton].forEach {self.addSubview($0)}
        
        //        let progress = displayFileProgress()
        //        self.addSubview(progress)
        //        progress.animate(toAngle: 360, duration: 5, completion: nil)
    }
//
//       override func setupConstraint() {
//            super.setupConstraint()
//    }
    
    @objc private func handleSetTimer(){
        // display popover menu to set timer
        let startPoint = CGPoint(x: timerButton.center.x, y: timerButton.frame.size.height * 2)
        let aView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width * 0.3, height: self.frame.height / 3))
        
        timePicker.frame = aView.frame
        aView.addSubview(timePicker)
        popover.show(aView, point: startPoint)
    }
    
//    private func displayFileProgress()  -> KDCircularProgress{
//        let progress = KDCircularProgress(frame: CGRect(x: 0, y: 0, width: self.frame.size.width * 0.9, height: self.frame.size.width * 0.9))
//        progress.startAngle = 0
//        progress.progressThickness = 0.2
//        progress.trackThickness = 0.6
//        progress.clockwise = true
//        progress.gradientRotateSpeed = 2
//        progress.roundedCorners = false
//        progress.glowMode = .forward
//        progress.glowAmount = 0.9
//        progress.set(colors: UIColor.cyan ,UIColor.white, UIColor.magenta, UIColor.white, UIColor.orange)
//        progress.center = CGPoint(x: self.center.x, y: self.center.y)
//        return progress
//    }
}

extension BrowserView: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 61
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        second = row
        popover.dismiss()
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row)"
    }
}
