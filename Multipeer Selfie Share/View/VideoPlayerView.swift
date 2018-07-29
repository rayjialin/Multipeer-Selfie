//
//  VideoPlayerView.swift
//  Multipeer Selfie Share
//
//  Created by ruijia lin on 7/29/18.
//  Copyright © 2018 ruijia lin. All rights reserved.
//

import UIKit
import AVKit

class VideoPlayerView: UIView {
    
//    var avPlayer: AVPlayer? = nil {
//        didSet{
//            guard let detailCGImage = AVPlayer. else {return}
//            detailImageView.image = UIImage(cgImage: detailCGImage, scale: 1, orientation: .right)
//        }
//    }
    
    // use as constraint to setup button size
    let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isHidden = true
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    let headerContainerView: UIView = {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = flatBlack
        return containerView
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
    
    let backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(backButtonIcon, for: .normal)
        return button
    }()
    
    
    let footerCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.alwaysBounceHorizontal = true
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    let filterCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.alwaysBounceHorizontal = true
        collectionView.isHidden = true
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    let footerDetailContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(white: 0.3, alpha: 0.3)
        view.isHidden = true
        return view
    }()
    
    let filterButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(filterIcon, for: .normal)
        return button
    }()
    
    let sweetAlert = SweetAlert()
    
    let footerContainerView: UIView = {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = flatBlack
        return containerView
    }()
    
//    let detailImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.isUserInteractionEnabled = true
//        imageView.contentMode = .scaleAspectFit
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        return imageView
//    }()
    
    let detailLabel: UILabel = {
        let label = UILabel()
        label.textColor = flatWhite
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = UIFont(name: gillSansFont, size: 14)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        setupConstraint()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(){
        
        // adding ui elements to header container
        [view1, view2, backButton, detailLabel].forEach {
            headerContainerView.addSubview($0)
        }
        
        // adding ui elements to footer container
        [footerCollectionView, thumbnailImageView, view3, view4, filterButton].forEach {footerContainerView.addSubview($0)}
        
        // adding ui elements to footer detail container
        [filterCollectionView].forEach {footerDetailContainer.addSubview($0)}
        
        // adding all containers to imageView - show all elements on top of image
//        [headerContainerView, footerContainerView, footerDetailContainer].forEach {detailImageView.addSubview($0)}
        
        // adding image view to parent view
        [headerContainerView, footerContainerView, footerDetailContainer].forEach {self.addSubview($0)}
    }
    
    func setupConstraint(){
        
        // use as constraint to setup button size
        thumbnailImageView.heightAnchor.constraint(equalTo: footerContainerView.heightAnchor, multiplier: 0.8).isActive = true
        thumbnailImageView.widthAnchor.constraint(equalTo: footerContainerView.heightAnchor, multiplier: 0.8).isActive = true
        thumbnailImageView.centerYAnchor.constraint(equalTo: footerContainerView.centerYAnchor).isActive = true
        thumbnailImageView.leadingAnchor.constraint(equalTo: footerContainerView.leadingAnchor, constant: 10).isActive = true
        
//        detailImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
//        detailImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
//        detailImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
//        detailImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        footerDetailContainer.widthAnchor.constraint(equalTo: footerContainerView.widthAnchor).isActive = true
        footerDetailContainer.heightAnchor.constraint(equalTo: footerContainerView.heightAnchor, multiplier: 0.5).isActive = true
        footerDetailContainer.bottomAnchor.constraint(equalTo: footerContainerView.topAnchor).isActive = true
        
        filterCollectionView.topAnchor.constraint(equalTo: footerDetailContainer.topAnchor).isActive = true
        filterCollectionView.leadingAnchor.constraint(equalTo: footerDetailContainer.leadingAnchor).isActive = true
        filterCollectionView.trailingAnchor.constraint(equalTo: footerDetailContainer.trailingAnchor).isActive = true
        filterCollectionView.bottomAnchor.constraint(equalTo: footerDetailContainer.bottomAnchor).isActive = true
        
        headerContainerView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
        headerContainerView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        headerContainerView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.1).isActive = true
        
        footerContainerView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        footerContainerView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        footerContainerView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.1).isActive = true
        
        view1.leadingAnchor.constraint(equalTo: headerContainerView.leadingAnchor).isActive = true
        view1.topAnchor.constraint(equalTo: headerContainerView.topAnchor).isActive = true
        view1.widthAnchor.constraint(equalTo: headerContainerView.widthAnchor, multiplier: 0.25).isActive = true
        view1.heightAnchor.constraint(equalTo: headerContainerView.heightAnchor, multiplier: 1).isActive = true
        
        view2.centerXAnchor.constraint(equalTo: headerContainerView.centerXAnchor).isActive = true
        view2.bottomAnchor.constraint(equalTo: headerContainerView.bottomAnchor).isActive = true
        view2.widthAnchor.constraint(equalTo: headerContainerView.widthAnchor, multiplier: 0.5).isActive = true
        view2.heightAnchor.constraint(equalTo: headerContainerView.heightAnchor, multiplier: 0.8).isActive = true
        //
        view3.leadingAnchor.constraint(equalTo: footerContainerView.leadingAnchor).isActive = true
        view3.topAnchor.constraint(equalTo: footerContainerView.topAnchor).isActive = true
        view3.widthAnchor.constraint(equalTo: footerContainerView.widthAnchor, multiplier: 0.25).isActive = true
        view3.heightAnchor.constraint(equalTo: footerContainerView.heightAnchor, multiplier: 1).isActive = true
        //
        view4.leadingAnchor.constraint(equalTo: view3.trailingAnchor).isActive = true
        view4.topAnchor.constraint(equalTo: footerContainerView.topAnchor).isActive = true
        view4.widthAnchor.constraint(equalTo: footerContainerView.widthAnchor, multiplier: 0.25).isActive = true
        view4.heightAnchor.constraint(equalTo: footerContainerView.heightAnchor, multiplier: 1).isActive = true
        
        backButton.bottomAnchor.constraint(equalTo: view1.bottomAnchor, constant: -10).isActive = true
        backButton.centerXAnchor.constraint(equalTo: view1.centerXAnchor).isActive = true
        backButton.heightAnchor.constraint(equalTo: thumbnailImageView.heightAnchor, multiplier: 0.3).isActive = true
        backButton.widthAnchor.constraint(equalTo: thumbnailImageView.heightAnchor, multiplier: 0.3).isActive = true
        
        filterButton.centerYAnchor.constraint(equalTo: view3.centerYAnchor).isActive = true
        filterButton.centerXAnchor.constraint(equalTo: view3.centerXAnchor).isActive = true
        filterButton.heightAnchor.constraint(equalTo: thumbnailImageView.heightAnchor, multiplier: 0.3).isActive = true
        filterButton.widthAnchor.constraint(equalTo: thumbnailImageView.heightAnchor, multiplier: 0.3).isActive = true
        
        detailLabel.bottomAnchor.constraint(equalTo: view2.bottomAnchor).isActive = true
        detailLabel.centerXAnchor.constraint(equalTo: view2.centerXAnchor).isActive = true
        detailLabel.heightAnchor.constraint(equalTo: view2.heightAnchor, multiplier: 1).isActive = true
        detailLabel.widthAnchor.constraint(equalTo: view2.widthAnchor, multiplier: 1).isActive = true
    }
}
