//
//  SocialCell.swift
//  Nibble
//
//  Created by Sawyer Billings on 3/26/18.
//  Copyright © 2018 Sawyer Billings. All rights reserved.
//

import UIKit

class SocialCell: UITableViewCell {
    
    var myLabel1 = UILabel()
    var profile = UIImageView()
    var detailLabel = UILabel()
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let marginGuide = contentView.layoutMarginsGuide
        contentView.backgroundColor = UIColor.clear
        backgroundView = UIImageView(image: UIImage(named: "cellbg")!)
        
        // configure titleLabel
        
        contentView.addSubview(profile)
        profile.contentMode = .scaleAspectFit
        profile.translatesAutoresizingMaskIntoConstraints = false
        profile.topAnchor.constraint(equalTo: marginGuide.topAnchor, constant: 10).isActive = true
        profile.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor, constant: -10).isActive = true
        profile.addConstraint(NSLayoutConstraint(item: profile, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 70))
        profile.addConstraint(NSLayoutConstraint(item: profile, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 70))
        profile.layer.cornerRadius = 35
        profile.layer.masksToBounds = true
        profile.clipsToBounds = true
        
        contentView.addSubview(myLabel1)
        myLabel1.textColor = UIColor.black
        myLabel1.font = UIFont(name: "Avenir-Heavy", size: 20)
        myLabel1.translatesAutoresizingMaskIntoConstraints = false
        myLabel1.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor, constant: 10).isActive = true
        myLabel1.topAnchor.constraint(equalTo: marginGuide.topAnchor, constant: 10).isActive = true
        myLabel1.numberOfLines = 0
        
        contentView.addSubview(detailLabel)
        detailLabel.translatesAutoresizingMaskIntoConstraints = false
        detailLabel.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor, constant: 10).isActive = true
        detailLabel.trailingAnchor.constraint(equalTo: profile.leadingAnchor, constant: -10).isActive = true
        detailLabel.topAnchor.constraint(equalTo: myLabel1.bottomAnchor, constant: 10).isActive = true
        detailLabel.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor, constant: -30).isActive = true
        detailLabel.numberOfLines = 0
        detailLabel.font = UIFont(name: "Avenir-Book", size: 15)
        detailLabel.textColor = UIColor.black
    }
}
