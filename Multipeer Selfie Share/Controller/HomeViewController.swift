//
//  ViewController.swift
//  Multipeer Selfie Share
//
//  Created by ruijia lin on 7/2/18.
//  Copyright © 2018 ruijia lin. All rights reserved.
//

import UIKit
import RealmSwift
import SwiftyButton

enum SegueToRole {
    case broadcast
    case browser
}

class HomeViewController: UIViewController {
    
    let cameraService = CameraServiceManager()
    
    let titleTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        let text = appName
        let mutatedText = NSMutableAttributedString(string: text)
        mutatedText.setColorForText(textForAttribute: "Multi", withColor: flatWhiteDark)
        mutatedText.setColorForText(textForAttribute: "Peer", withColor: flatWhiteDark)
        mutatedText.setColorForText(textForAttribute: "Selfie", withColor: flatGreenDark)
        // Create a shadow
        let shadow = NSShadow()
        shadow.shadowBlurRadius = 3
        shadow.shadowOffset = CGSize(width: 3, height: 3)
        shadow.shadowColor = UIColor.gray
        // Create an attribute from the shadow
        let shadowAttribute = [NSAttributedStringKey.shadow: shadow]
        // Add the attribute to the string
        let textRange = NSMakeRange(0, text.count)
        mutatedText.addAttribute(NSAttributedStringKey.shadow, value: shadow, range: textRange)
        textField.attributedText = mutatedText
        textField.font = UIFont(name: gillSansFont, size: 36)
        textField.adjustsFontSizeToFitWidth = true
        textField.font = UIFont.boldSystemFont(ofSize: 36)
        textField.textAlignment = .center
        return textField
    }()
    
    let instructionTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.text = appDescription
        textView.textAlignment = .center
        textView.font = UIFont(name: gillSansFont, size: 18)
        textView.textColor = flatWhiteDark
        textView.backgroundColor = .clear
        return textView
    }()
    
    let chooseRoleTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont(name: gillSansFont, size: 24)
        textField.textColor = flatWhiteDark
        textField.text = selectRoleText
        textField.textAlignment = .center
        return textField
    }()
    
    let divider: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = flatWhiteDark
        return view
    }()
    
    // Camera Button
    let cameraRoleButton: PressableButton = {
        let button = PressableButton()
        button.frame.size = CGSize(width: 150, height: 150)
        let image = #imageLiteral(resourceName: "cameraIcon").withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.imageView?.tintColor = flatGreen
        button.imageView?.contentMode = .scaleAspectFit
        button.imageEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        button.addTarget(self, action: #selector(registerCameraRole), for: .touchUpInside)
        button.clipsToBounds = true
        button.shadowHeight = 5
        button.depth = 1
        button.colors = .init(button: .clear, shadow: .clear)
        return button
    }()
    
    // Remote Button
    let browserRoleButton: PressableButton = {
        let button = PressableButton()
        button.frame.size = CGSize(width: 150, height: 150)
        let image = remoteRoleIcon.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.imageView?.tintColor = flatGreen
        button.imageEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        button.addTarget(self, action: #selector(registerRemoteRole), for: .touchUpInside)
        button.clipsToBounds = true
        button.shadowHeight = 5
        button.depth = 1
        button.colors = .init(button: .clear, shadow: .clear)
        return button
    }()
    
    let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 10
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonStackView.addArrangedSubview(cameraRoleButton)
        buttonStackView.addArrangedSubview(browserRoleButton)
        [titleTextField, instructionTextView, chooseRoleTextField, buttonStackView, divider].forEach {view.addSubview($0)}
        
        setupConstraint()
    }
    
    private func setupConstraint(){
        titleTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 60).isActive = true
        titleTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        
        instructionTextView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 20).isActive = true
        instructionTextView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        instructionTextView.widthAnchor.constraint(equalTo: titleTextField.widthAnchor).isActive = true
        instructionTextView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2).isActive = true
        
        chooseRoleTextField.topAnchor.constraint(equalTo: instructionTextView.bottomAnchor, constant: 20).isActive = true
        chooseRoleTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        chooseRoleTextField.widthAnchor.constraint(equalTo: instructionTextView.widthAnchor, multiplier: 0.9).isActive = true
        
        divider.topAnchor.constraint(equalTo: chooseRoleTextField.bottomAnchor, constant: 5).isActive = true
        divider.widthAnchor.constraint(equalTo: chooseRoleTextField.widthAnchor).isActive = true
        divider.heightAnchor.constraint(equalToConstant: 1).isActive = true
        divider.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        buttonStackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        buttonStackView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2).isActive = true
        buttonStackView.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: 10).isActive = true
        buttonStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    @objc private func registerCameraRole(sender: PressableButton){
            self.performSegue(withIdentifier: segueToBroadcast, sender: SegueToRole.broadcast)
            self.cameraService.broadcaster = self.cameraService.myPeerId
    }
    
    @objc private func registerRemoteRole(sender: PressableButton){
            self.performSegue(withIdentifier: segueToBrowse, sender: SegueToRole.browser)
    }
}

