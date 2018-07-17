//
//  PhotoDetailViewController.swift
//  Multipeer Selfie Share
//
//  Created by ruijia lin on 7/15/18.
//  Copyright © 2018 ruijia lin. All rights reserved.
//

import UIKit
import Chameleon

class PhotoDetailViewController: UIViewController {
    
    let sweetAlert = SweetAlert()
    var imageData: Data?
    
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
    
    let detailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "backIcon"), for: .normal)
        return button
    }()
    
    let view1: UIView = {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        return containerView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let data = imageData else {return}
        detailImageView.frame = view.frame
        detailImageView.image = UIImage(data: data)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        [view1, backButton].forEach {
            headerContainerView.addSubview($0)
        }
        
        [headerContainerView, footerContainerView].forEach {detailImageView.addSubview($0)}
        [detailImageView].forEach {view.addSubview($0)}
        
        setupConstraint()
        
        backButton.addTarget(self, action: #selector(handleBackButtonPressed), for: .touchUpInside)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleImageTapped))
        tapGesture.numberOfTapsRequired = 1
        let longPressedGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressed))
        longPressedGesture.minimumPressDuration = 1.0
        detailImageView.addGestureRecognizer(tapGesture)
        detailImageView.addGestureRecognizer(longPressedGesture)
    }
    
    @objc private func handleBackButtonPressed() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func handleImageTapped() {
        if headerContainerView.isHidden == true && footerContainerView.isHidden == true {
            [headerContainerView, footerContainerView].forEach { $0.isHidden = false }
        }else {
            [headerContainerView, footerContainerView].forEach { $0.isHidden = true }
        }
    }
    
    @objc private func handleLongPressed(longPressed: UILongPressGestureRecognizer){
        guard longPressed.state == UIGestureRecognizerState.began else {return}
        //Chaining alerts with messages on button click
        SweetAlert().showAlert("Save Photo", subTitle: "Do you want to save this photo to Photo Album?", style: AlertStyle.success, buttonTitle:"Yes", buttonColor: UIColor.flatGreen(), otherButtonTitle:  "No", otherButtonColor: UIColor.flatGreen()) { (isOtherButton) -> Void in
            if isOtherButton == true {

                guard let image = self.detailImageView.image else {return}
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);

             let _ = self.sweetAlert.showAlert("Saved", subTitle: "Photo has been saved", style: AlertStyle.success)
            }
            else {
             let _ = self.sweetAlert.showAlert("Cancelled", subTitle: "Action Cancelled", style: AlertStyle.error)
            }
        }
    }
    
    private func setupConstraint(){
        headerContainerView.topAnchor.constraint(equalTo: detailImageView.topAnchor).isActive = true
        headerContainerView.widthAnchor.constraint(equalTo: detailImageView.widthAnchor).isActive = true
        headerContainerView.heightAnchor.constraint(equalTo: detailImageView.heightAnchor, multiplier: 0.1).isActive = true
        
        footerContainerView.bottomAnchor.constraint(equalTo: detailImageView.bottomAnchor).isActive = true
        footerContainerView.widthAnchor.constraint(equalTo: detailImageView.widthAnchor).isActive = true
        footerContainerView.heightAnchor.constraint(equalTo: detailImageView.heightAnchor, multiplier: 0.1).isActive = true
        
        view1.leadingAnchor.constraint(equalTo: headerContainerView.leadingAnchor).isActive = true
        view1.topAnchor.constraint(equalTo: headerContainerView.topAnchor).isActive = true
        view1.widthAnchor.constraint(equalTo: headerContainerView.widthAnchor, multiplier: 0.25).isActive = true
        view1.heightAnchor.constraint(equalTo: headerContainerView.heightAnchor, multiplier: 1).isActive = true
        
        backButton.bottomAnchor.constraint(equalTo: view1.bottomAnchor, constant: -10).isActive = true
        backButton.centerXAnchor.constraint(equalTo: view1.centerXAnchor).isActive = true
        backButton.heightAnchor.constraint(equalTo: detailImageView.widthAnchor, multiplier: 0.07).isActive = true
        backButton.widthAnchor.constraint(equalTo: detailImageView.widthAnchor, multiplier: 0.07).isActive = true
    }
    


}
