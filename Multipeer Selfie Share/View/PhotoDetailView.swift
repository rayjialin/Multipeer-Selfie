//
//  PhotoDetailView.swift
//  Multipeer Selfie Share
//
//  Created by ruijia lin on 7/20/18.
//  Copyright © 2018 ruijia lin. All rights reserved.
//

import UIKit

class PhotoDetailView: UIView {

    var detailImage: UIImage? = nil {
        didSet{
            guard let detailCGImage = detailImage?.cgImage else {return}
            detailImageView.image = UIImage(cgImage: detailCGImage, scale: 1, orientation: UIImageOrientation.right)
        }
    }
    
    let filterCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.allowsMultipleSelection = true
        collectionView.alwaysBounceHorizontal = true
        collectionView.isHidden = true
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
        button.setImage(#imageLiteral(resourceName: "filterIcon"), for: .normal)
        return button
    }()
    
    let sweetAlert = SweetAlert()
    
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
        imageView.translatesAutoresizingMaskIntoConstraints = false
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
        [view1, backButton].forEach {
            headerContainerView.addSubview($0)
        }
        
        // adding ui elements to footer container
        [filterButton].forEach {footerContainerView.addSubview($0)}
        
        // adding ui elements to footer detail container
        [filterCollectionView].forEach {footerDetailContainer.addSubview($0)}
        
        // adding all containers to imageView - show all elements on top of image
        [headerContainerView, footerContainerView, footerDetailContainer].forEach {detailImageView.addSubview($0)}
        
        // adding image view to parent view
        [detailImageView].forEach {self.addSubview($0)}
    }
    
    func setupConstraint(){
        
        detailImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        detailImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        detailImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        detailImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        footerDetailContainer.widthAnchor.constraint(equalTo: footerContainerView.widthAnchor).isActive = true
        footerDetailContainer.heightAnchor.constraint(equalTo: footerContainerView.heightAnchor, multiplier: 0.5).isActive = true
        footerDetailContainer.bottomAnchor.constraint(equalTo: footerContainerView.topAnchor).isActive = true

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
        
        filterButton.bottomAnchor.constraint(equalTo: footerContainerView.bottomAnchor, constant: -10).isActive = true
        filterButton.leadingAnchor.constraint(equalTo: footerContainerView.leadingAnchor, constant: 10).isActive = true
        filterButton.widthAnchor.constraint(equalTo: backButton.widthAnchor).isActive = true
        filterButton.heightAnchor.constraint(equalTo: backButton.heightAnchor).isActive = true
    }
    
}
