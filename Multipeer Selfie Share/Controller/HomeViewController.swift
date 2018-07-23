//
//  ViewController.swift
//  Multipeer Selfie Share
//
//  Created by ruijia lin on 7/2/18.
//  Copyright © 2018 ruijia lin. All rights reserved.
//

import UIKit
import Chameleon
import RealmSwift

enum SegueToRole {
    case broadcast
    case browser
}

class HomeViewController: UIViewController {
    
    let cameraService = CameraServiceManager()
    
    let titleTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        let text = "MultiPeer Selfie"
        let mutatedText = NSMutableAttributedString(string: text)
        mutatedText.setColorForText(textForAttribute: "Multi", withColor: UIColor.flatWhiteColorDark())
        mutatedText.setColorForText(textForAttribute: "Peer", withColor: UIColor.flatWhiteColorDark())
        mutatedText.setColorForText(textForAttribute: "Selfie", withColor: UIColor.flatGreenColorDark())
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
        textField.font = UIFont(name: "GillSans", size: 36)
        textField.adjustsFontSizeToFitWidth = true
        textField.font = UIFont.boldSystemFont(ofSize: 36)
        textField.textAlignment = .center
        return textField
    }()
    
    let instructionTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        let string = "All of the devices should be on the same WIFI or have bluetooth enabled to be able to detect each other"
        textView.text = string
        textView.textAlignment = .center
        textView.font = UIFont(name: "GillSans", size: 18)
        textView.textColor = UIColor.flatWhiteColorDark()
        textView.backgroundColor = .clear
        return textView
    }()
    
    let chooseRoleTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont(name: "GillSans", size: 24)
        textField.textColor = UIColor.flatWhiteColorDark()
        textField.text = "Select Your Role"
        textField.textAlignment = .center
        return textField
    }()
    
    let divider: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.flatWhiteColorDark()
        return view
    }()
    
    // Take-Photo Button
    let cameraRoleButton: DOFavoriteButton = {
        let button = DOFavoriteButton(frame: CGRect(x: 0, y: 0, width: 200, height: 200), image: #imageLiteral(resourceName: "cameraIcon"))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(registerCameraRole), for: .touchUpInside)
        button.imageColorOff = UIColor.flatGray()
        button.imageColorOn = UIColor.flatGreen()
        button.circleColor = UIColor.flatGreen()
        button.lineColor = UIColor.flatGreen()
        return button
    }()
    
    // Take-Photo Button
    let browserRoleButton: DOFavoriteButton = {
        let button = DOFavoriteButton(frame: CGRect(x: 0, y: 0, width: 200, height: 200), image: #imageLiteral(resourceName: "remoteIcon"))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(registerRemoteRole), for: .touchUpInside)
        button.imageColorOff = UIColor.flatGray()
        button.imageColorOn = UIColor.flatGreen()
        button.circleColor = UIColor.flatGreen()
        button.lineColor = UIColor.flatGreen()
        return button
    }()
    
    let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 5
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
        
        buttonStackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1).isActive = true
        buttonStackView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2).isActive = true
        buttonStackView.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: 10).isActive = true
    }
    
    @objc private func registerCameraRole(sender: DOFavoriteButton){
        cameraRoleButton.isEnabled = false
        sender.select()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
            self.performSegue(withIdentifier: "segueToBroadcast", sender: SegueToRole.broadcast)
            self.cameraService.broadcaster = self.cameraService.myPeerId
            sender.deselect()
            self.cameraRoleButton.isEnabled = true
        }
    }
    
    @objc private func registerRemoteRole(sender: DOFavoriteButton){
        browserRoleButton.isEnabled = false
        sender.select()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
            self.performSegue(withIdentifier: "segueToBrowse", sender: SegueToRole.browser)
            sender.deselect()
            self.browserRoleButton.isEnabled = true
        }
    }
}

extension NSMutableAttributedString {
    
    func setColorForText(textForAttribute: String, withColor color: UIColor) {
        let range: NSRange = self.mutableString.range(of: textForAttribute, options: .caseInsensitive)
        
        // Swift 4.1 and below
        self.addAttribute(NSAttributedStringKey.foregroundColor, value: color, range: range)
    }
    
}

