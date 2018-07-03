//
//  BrowserView.swift
//  Multipeer Selfie Share
//
//  Created by ruijia lin on 7/3/18.
//  Copyright © 2018 ruijia lin. All rights reserved.
//

import UIKit

class BrowserView: UIView {

//    let browserViewController = BrowserViewController()
    let uiMethods = UIMethods()
    
    // Take-Photo Button
    let takePhotoButton: UIButton = {
       let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.showsTouchWhenHighlighted = true
        button.setImage(#imageLiteral(resourceName: "circle"), for: .normal)
        button.addTarget(self, action: #selector(handleTakePhoto), for: .touchUpInside)
        return button
    }()
    
    // Toggle Flash Button
    let flashButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.showsTouchWhenHighlighted = true
        button.setImage(#imageLiteral(resourceName: "flashAuto"), for: .normal)
        button.addTarget(self, action: #selector(handleFlashToggle), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        setupConstraint()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        [takePhotoButton, flashButton].forEach {self.addSubview($0)}
    }
    
    private func setupConstraint() {
        takePhotoButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        takePhotoButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        takePhotoButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8).isActive = true
        takePhotoButton.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8).isActive = true
        
        flashButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 30).isActive = true
        flashButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        flashButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.1).isActive = true
        flashButton.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.1).isActive = true
    }
    
    @objc private func handleTakePhoto(){
        uiMethods.takePhoto()
    }
    
    @objc private func handleFlashToggle(sender: Any){
        var state = ""
        guard let flashButton = sender as? UIButton else {return}
        
        switch flashButton.currentImage {
        case #imageLiteral(resourceName: "flashAuto"):
            flashButton.setImage(#imageLiteral(resourceName: "flashOn"), for: .normal)
            state = flashState.flashOn.strValue()
            break
        case #imageLiteral(resourceName: "flashOn"):
            flashButton.setImage(#imageLiteral(resourceName: "flashOff"), for: .normal)
            state = flashState.flashOff.strValue()
            break
        case #imageLiteral(resourceName: "flashOff"):
            flashButton.setImage(#imageLiteral(resourceName: "flashAuto"), for: .normal)
            state = flashState.flashAuto.strValue()
            break
        default:
            flashButton.setImage(#imageLiteral(resourceName: "flashAuto"), for: .normal)
            state = flashState.flashAuto.strValue()
        }
        
        uiMethods.flashToggled(state: state)
        
    }

}
