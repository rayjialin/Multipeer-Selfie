//
//  BrowserView.swift
//  Multipeer Selfie Share
//
//  Created by ruijia lin on 7/3/18.
//  Copyright © 2018 ruijia lin. All rights reserved.
//

import UIKit
import AVFoundation

class BrowserView: UIView {
    
    var bottomConstraint = NSLayoutConstraint()
    var trailingConstraint = NSLayoutConstraint()
    var widthConstraint = NSLayoutConstraint()
    var heightConstraint = NSLayoutConstraint()
    let timePicker = UIPickerView()
    let popover = Popover()
    
    var torchMode: AVCaptureDevice.TorchMode {
        didSet{
            switch torchMode {
            case .auto:
                flashButton.imageView?.image = #imageLiteral(resourceName: "flashAuto")
            case .off:
                flashButton.imageView?.image = #imageLiteral(resourceName: "flashOff")
            case .on:
                flashButton.imageView?.image = #imageLiteral(resourceName: "flashOn")
            default:
                flashButton.imageView?.image = #imageLiteral(resourceName: "flashOff")
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
    
    let timerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Take-Photo Button
    let takePhotoButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.showsTouchWhenHighlighted = true
        button.setImage(#imageLiteral(resourceName: "circle"), for: UIControl.State.normal)
        return button
    }()
    
    // Toggle Flash Button
    let flashButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.showsTouchWhenHighlighted = true
        button.setImage(#imageLiteral(resourceName: "flashOff"), for: UIControl.State.normal)
        return button
    }()
    
    // Set Timer Button
    let timerButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.showsTouchWhenHighlighted = true
        button.setImage(#imageLiteral(resourceName: "timer"), for: UIControl.State.normal)
        button.addTarget(self, action: #selector(handleSetTimer), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    let thumbNailImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        imageView.layer.borderWidth = 3
        imageView.isUserInteractionEnabled = true
        imageView.backgroundColor = .black
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true
        return imageView
    }()
    
    let connectButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.showsTouchWhenHighlighted = true
        button.setImage(#imageLiteral(resourceName: "connect"), for: UIControl.State.normal)
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
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        [takePhotoButton, flashButton, timerButton, timerLabel, thumbNailImage, connectButton].forEach {self.addSubview($0)}
        
        //        let progress = displayFileProgress()
        //        self.addSubview(progress)
        //        progress.animate(toAngle: 360, duration: 5, completion: nil)
    }
    
    private func setupConstraint() {
        takePhotoButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        takePhotoButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        takePhotoButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8).isActive = true
        takePhotoButton.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8).isActive = true
        
        timerButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 30).isActive = true
        timerButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        timerButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.1).isActive = true
        timerButton.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.1).isActive = true
        
        flashButton.topAnchor.constraint(equalTo: timerButton.topAnchor).isActive = true
        flashButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        flashButton.widthAnchor.constraint(equalTo: timerButton.widthAnchor).isActive = true
        flashButton.heightAnchor.constraint(equalTo: timerButton.heightAnchor).isActive = true
        
        timerLabel.topAnchor.constraint(equalTo: timerButton.topAnchor).isActive = true
        timerLabel.trailingAnchor.constraint(equalTo: timerButton.leadingAnchor, constant: -5).isActive = true
        timerLabel.widthAnchor.constraint(equalTo: timerButton.widthAnchor, multiplier: 0.6).isActive = true
        timerLabel.heightAnchor.constraint(equalTo: timerButton.heightAnchor).isActive = true
        
        bottomConstraint = thumbNailImage.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
        bottomConstraint.isActive = true
        trailingConstraint = thumbNailImage.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10)
        trailingConstraint.isActive = true
        widthConstraint = thumbNailImage.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.2)
        widthConstraint.isActive = true
        heightConstraint = thumbNailImage.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.2)
        heightConstraint.isActive = true
        
        connectButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        connectButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        connectButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.1).isActive = true
        connectButton.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.1).isActive = true
    }
    
    @objc private func handleSetTimer(){
        // display popover menu to set timer
        let startPoint = CGPoint(x: timerButton.center.x, y: timerButton.frame.size.height * 2)
        let aView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width * 0.3, height: self.frame.height / 3))
        
        timePicker.frame = aView.frame
        aView.addSubview(timePicker)
        popover.show(aView, point: startPoint)
    }
    
    private func displayFileProgress()  -> KDCircularProgress{
        let progress = KDCircularProgress(frame: CGRect(x: 0, y: 0, width: self.frame.size.width * 0.9, height: self.frame.size.width * 0.9))
        progress.startAngle = 0
        progress.progressThickness = 0.2
        progress.trackThickness = 0.6
        progress.clockwise = true
        progress.gradientRotateSpeed = 2
        progress.roundedCorners = false
        progress.glowMode = .forward
        progress.glowAmount = 0.9
        progress.set(colors: UIColor.cyan ,UIColor.white, UIColor.magenta, UIColor.white, UIColor.orange)
        progress.center = CGPoint(x: self.center.x, y: self.center.y)
        return progress
    }
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
