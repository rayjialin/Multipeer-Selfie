//
//  ViewController.swift
//  Multipeer Selfie Share
//
//  Created by ruijia lin on 7/2/18.
//  Copyright © 2018 ruijia lin. All rights reserved.
//

import UIKit

enum SegueToRole {
    case broadcast
    case browser
}

class HomeViewController: UIViewController {
    
    let cameraService = CameraServiceManager()
    
    let titleTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.text = "Selfie Party"
        textField.adjustsFontSizeToFitWidth = true
        textField.font = UIFont.boldSystemFont(ofSize: 36)
        textField.textAlignment = .center
        return textField
    }()
    
    let instructionTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.text = "All of the devices should be on the same WIFI or have bluetooth enabled to be able to detect each other"
        textView.textAlignment = .center
        textView.backgroundColor = UIColor(red: 0.969, green: 0.969, blue: 0.969, alpha: 1)
        textView.font = UIFont.boldSystemFont(ofSize: 16)
        textView.backgroundColor = .clear
        return textView
    }()
    
    let chooseRoleTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.text = "What should this device be?"
        textField.textAlignment = .center
        return textField
    }()
    
    // Take-Photo Button
    let cameraRoleButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.showsTouchWhenHighlighted = true
        button.setTitle("Camera", for: .normal)
        button.backgroundColor = UIColor(red: 48, green: 159, blue: 215, alpha: 1)
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(registerCameraRole), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    // Take-Photo Button
    let browserRoleButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.showsTouchWhenHighlighted = true
        button.backgroundColor = UIColor(red: 48, green: 159, blue: 215, alpha: 1)
        button.layer.cornerRadius = 16
        button.setTitle("Remote", for: .normal)
        button.addTarget(self, action: #selector(registerRemoteRole), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        [titleTextField, instructionTextView, chooseRoleTextField, cameraRoleButton, browserRoleButton].forEach {view.addSubview($0)}
        
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
        
        cameraRoleButton.topAnchor.constraint(equalTo: chooseRoleTextField.bottomAnchor, constant: 20).isActive = true
        cameraRoleButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        cameraRoleButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
        cameraRoleButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2).isActive = true
        
        browserRoleButton.topAnchor.constraint(equalTo: cameraRoleButton.bottomAnchor, constant: 20).isActive = true
        browserRoleButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        browserRoleButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
        browserRoleButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2).isActive = true
    }
    
    @objc private func registerCameraRole(){
        performSegue(withIdentifier: "segueToBroadcast", sender: SegueToRole.broadcast)
        cameraService.broadcaster = cameraService.myPeerId
    }
    
    @objc private func registerRemoteRole(){
        performSegue(withIdentifier: "segueToBrowse", sender: SegueToRole.browser)
    }
}

