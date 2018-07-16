//
//  BaseView.swift
//  Multipeer Selfie Share
//
//  Created by ruijia lin on 7/15/18.
//  Copyright © 2018 ruijia lin. All rights reserved.
//

import UIKit

class BaseView: UIView {
    
    let timerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Toggle Flash Button
    let flashButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.showsTouchWhenHighlighted = true
        button.setImage(#imageLiteral(resourceName: "flashOffIcon"), for: .normal)
        return button
    }()
    
    // Set Timer Button
    let timerButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.showsTouchWhenHighlighted = true
        button.setImage(#imageLiteral(resourceName: "timerIcon"), for: .normal)
        return button
    }()
    
    let connectButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.showsTouchWhenHighlighted = true
        button.setImage(#imageLiteral(resourceName: "connectIcon"), for: .normal)
        return button
    }()
    
    let backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "backIcon"), for: .normal)
        return button
    }()
    
    let headerContainerView: UIView = {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = UIColor.flatBlack()
        return containerView
    }()
    
    let footerContainerView: UIView = {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = UIColor.flatBlack()
        return containerView
    }()
    
    let headerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.alignment = .fill
        stackView.spacing = 5
        stackView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        [backButton, connectButton, flashButton, timerButton].forEach {
            $0.imageEdgeInsets = UIEdgeInsets(top: 35, left: 30, bottom: 15, right: 30)
            headerStackView.addArrangedSubview($0)
        }
        
        headerContainerView.addSubview(headerStackView)
        [headerContainerView, footerContainerView].forEach {self.addSubview($0)}
        
//        [flashButton, timerButton, timerLabel, connectButton, backButton, headerContainerView, footerContainerView].forEach {self.addSubview($0)}
        setupConstraint()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraint(){
        headerStackView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        headerStackView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        headerStackView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.1).isActive = true
        
        headerContainerView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        headerContainerView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        headerContainerView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.1).isActive = true
        
        footerContainerView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        footerContainerView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        footerContainerView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.1).isActive = true

    }
    
}
