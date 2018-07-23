//
//  FilterCell.swift
//  Multipeer Selfie Share
//
//  Created by ruijia lin on 7/20/18.
//  Copyright © 2018 ruijia lin. All rights reserved.
//

import UIKit

class FilterCell: UICollectionViewCell {
    
    let filterLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = UIColor.flatWhite()
        label.font = UIFont(name: "GillSans", size: 12)
        return label
    }()
    
    let bottomBar: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.flatGreen()
        view.isHidden = true
        return view
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
        self.addSubview(filterLabel)
        self.addSubview(bottomBar)
    }
    
    private func setupConstraint(){
        filterLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5).isActive = true
        filterLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5).isActive = true
        filterLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        filterLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5).isActive = true
        
        bottomBar.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -3).isActive = true
        bottomBar.heightAnchor.constraint(equalToConstant: 3).isActive = true
        bottomBar.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8).isActive = true
        bottomBar.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    }
    
}
