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
        self.addSubview(filterLabel)
    }
    
    private func setupConstraint(){
        filterLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        filterLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.8).isActive = true
        filterLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5).isActive = true
        filterLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 5).isActive = true
    }
    
}
