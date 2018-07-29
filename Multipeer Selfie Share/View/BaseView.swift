//
//  BaseView.swift
//  Multipeer Selfie Share
//
//  Created by ruijia lin on 7/15/18.
//  Copyright © 2018 ruijia lin. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class BaseView: UIView {
    
    let timerLabel: UILabel = {
        let label = UILabel()
        label.textColor = flatWhite
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // view for progress bar
    let progressBarView: NVActivityIndicatorView = {
        let view = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50), type: .ballGridPulse, color: .white, padding: 0)
        return view
    }()
    
    // Toggle Flash Button
    let flashButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.showsTouchWhenHighlighted = true
        button.setImage(flashAutoIcon, for: .normal)
        return button
    }()
    
    // Set Timer Button
    let timerButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.showsTouchWhenHighlighted = true
        button.setImage(timerIcon, for: .normal)
        return button
    }()
    
    let connectButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.showsTouchWhenHighlighted = true
        button.setImage(connectionIcon, for: .normal)
        return button
    }()
    
    let backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(backButtonIcon, for: .normal)
        return button
    }()
    
    let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isHidden = true
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    let switchCameraButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.showsTouchWhenHighlighted = true
        button.setImage(switchCameraIcon, for: .normal)
        return button
    }()
    
    let view1: UIView = {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        return containerView
    }()
    
    let view2: UIView = {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        return containerView
    }()
    
    let view3: UIView = {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        return containerView
    }()
    
    let view4: UIView = {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        return containerView
    }()
    
    let headerContainerView: UIView = {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = flatBlack
        return containerView
    }()
    
    let footerContainerView: UIView = {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = flatBlack
        return containerView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        [view1, view2, view3, view4, backButton, connectButton, flashButton, timerButton, timerLabel].forEach {
            headerContainerView.addSubview($0)
        }
        [thumbnailImageView, switchCameraButton, progressBarView].forEach { footerContainerView.addSubview($0)}
        [headerContainerView, footerContainerView].forEach {self.addSubview($0)}
        setupConstraint()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        [view1, view2, view3, view4, backButton, connectButton, flashButton, timerButton, timerLabel].forEach {
            headerContainerView.addSubview($0)
        }
        [thumbnailImageView, switchCameraButton, progressBarView].forEach { footerContainerView.addSubview($0)}
        [headerContainerView, footerContainerView].forEach {self.addSubview($0)}
        setupConstraint()
        
    }
    
    func setupConstraint(){
        
        headerContainerView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        headerContainerView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        headerContainerView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.1).isActive = true
        
        footerContainerView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        footerContainerView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        footerContainerView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.1).isActive = true
        
        thumbnailImageView.heightAnchor.constraint(equalTo: footerContainerView.heightAnchor, multiplier: 0.8).isActive = true
        thumbnailImageView.widthAnchor.constraint(equalTo: footerContainerView.heightAnchor, multiplier: 0.8).isActive = true
        thumbnailImageView.centerYAnchor.constraint(equalTo: footerContainerView.centerYAnchor).isActive = true
        thumbnailImageView.leadingAnchor.constraint(equalTo: footerContainerView.leadingAnchor, constant: 10).isActive = true
        
        switchCameraButton.heightAnchor.constraint(equalTo: thumbnailImageView.heightAnchor, multiplier: 0.3).isActive = true
        switchCameraButton.widthAnchor.constraint(equalTo: thumbnailImageView.heightAnchor, multiplier: 0.3).isActive = true
        switchCameraButton.centerYAnchor.constraint(equalTo: footerContainerView.centerYAnchor).isActive = true
        switchCameraButton.trailingAnchor.constraint(equalTo: footerContainerView.trailingAnchor, constant: -10).isActive = true

        view1.leadingAnchor.constraint(equalTo: headerContainerView.leadingAnchor).isActive = true
        view1.topAnchor.constraint(equalTo: headerContainerView.topAnchor).isActive = true
        view1.widthAnchor.constraint(equalTo: headerContainerView.widthAnchor, multiplier: 0.25).isActive = true
        view1.heightAnchor.constraint(equalTo: headerContainerView.heightAnchor, multiplier: 1).isActive = true

        view2.leadingAnchor.constraint(equalTo: view1.trailingAnchor).isActive = true
        view2.topAnchor.constraint(equalTo: headerContainerView.topAnchor).isActive = true
        view2.widthAnchor.constraint(equalTo: headerContainerView.widthAnchor, multiplier: 0.25).isActive = true
        view2.heightAnchor.constraint(equalTo: headerContainerView.heightAnchor, multiplier: 1).isActive = true
//
        view3.leadingAnchor.constraint(equalTo: view2.trailingAnchor).isActive = true
        view3.topAnchor.constraint(equalTo: headerContainerView.topAnchor).isActive = true
        view3.widthAnchor.constraint(equalTo: headerContainerView.widthAnchor, multiplier: 0.25).isActive = true
        view3.heightAnchor.constraint(equalTo: headerContainerView.heightAnchor, multiplier: 1).isActive = true
//
        view4.leadingAnchor.constraint(equalTo: view3.trailingAnchor).isActive = true
        view4.topAnchor.constraint(equalTo: headerContainerView.topAnchor).isActive = true
        view4.widthAnchor.constraint(equalTo: headerContainerView.widthAnchor, multiplier: 0.25).isActive = true
        view4.heightAnchor.constraint(equalTo: headerContainerView.heightAnchor, multiplier: 1).isActive = true
        
        backButton.bottomAnchor.constraint(equalTo: view1.bottomAnchor, constant: -10).isActive = true
        backButton.centerXAnchor.constraint(equalTo: view1.centerXAnchor).isActive = true
        backButton.heightAnchor.constraint(equalTo: thumbnailImageView.heightAnchor, multiplier: 0.3).isActive = true
        backButton.widthAnchor.constraint(equalTo: thumbnailImageView.heightAnchor, multiplier: 0.3).isActive = true

        connectButton.bottomAnchor.constraint(equalTo: view2.bottomAnchor, constant: -10).isActive = true
        connectButton.centerXAnchor.constraint(equalTo: view2.centerXAnchor).isActive = true
        connectButton.heightAnchor.constraint(equalTo: thumbnailImageView.heightAnchor, multiplier: 0.3).isActive = true
        connectButton.widthAnchor.constraint(equalTo: thumbnailImageView.heightAnchor, multiplier: 0.3).isActive = true
        
        flashButton.bottomAnchor.constraint(equalTo: view3.bottomAnchor, constant: -10).isActive = true
        flashButton.centerXAnchor.constraint(equalTo: view3.centerXAnchor).isActive = true
        flashButton.heightAnchor.constraint(equalTo: thumbnailImageView.heightAnchor, multiplier: 0.3).isActive = true
        flashButton.widthAnchor.constraint(equalTo: thumbnailImageView.heightAnchor, multiplier: 0.3).isActive = true

        timerButton.bottomAnchor.constraint(equalTo: view4.bottomAnchor, constant: -10).isActive = true
        timerButton.centerXAnchor.constraint(equalTo: view4.centerXAnchor).isActive = true
        timerButton.heightAnchor.constraint(equalTo: thumbnailImageView.heightAnchor, multiplier: 0.3).isActive = true
        timerButton.widthAnchor.constraint(equalTo: thumbnailImageView.heightAnchor, multiplier: 0.3).isActive = true
        
        timerLabel.trailingAnchor.constraint(equalTo: timerButton.leadingAnchor, constant: -5).isActive = true
        timerLabel.centerYAnchor.constraint(equalTo: timerButton.centerYAnchor).isActive = true
        timerLabel.widthAnchor.constraint(equalTo: timerButton.widthAnchor, multiplier: 1.5).isActive = true
        timerLabel.heightAnchor.constraint(equalTo: timerButton.heightAnchor).isActive = true        
    }
    
}
