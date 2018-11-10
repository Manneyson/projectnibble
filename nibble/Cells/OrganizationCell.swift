//
//  OrganizationCell.swift
//  nibble
//
//  Created by Sawyer Billings on 10/26/18.
//  Copyright © 2018 sbilling. All rights reserved.
//

import UIKit

class OrganizationCell: UITableViewCell {
    var name = UILabel()
    var info = UILabel()
    var icon = UIImageView()
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let marginGuide = contentView.layoutMarginsGuide
        
        contentView.addSubview(name)
        contentView.addSubview(info)
        contentView.addSubview(icon)
        
        name.translatesAutoresizingMaskIntoConstraints = false
        name.topAnchor.constraint(equalTo: marginGuide.topAnchor, constant: 0).isActive = true
        name.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor, constant: 0).isActive = true
        name.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor, constant: -100).isActive = true
        name.textColor = UIColor.black
        name.font = UIFont(name: "Avenir-Heavy", size: 16)
        name.numberOfLines = 0
        
        info.translatesAutoresizingMaskIntoConstraints = false
        info.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 10).isActive = true
        info.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor, constant: 0).isActive = true
        info.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor, constant: -60).isActive = true
        info.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor, constant: 0).isActive = true
        info.textColor = UIColor.black
        info.font = UIFont(name: "Avenir", size: 14)
        info.numberOfLines = 0
        
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.topAnchor.constraint(equalTo: marginGuide.topAnchor, constant: 0).isActive = true
        icon.bottomAnchor.constraint(equalTo: marginGuide.topAnchor, constant: 50).isActive = true
        icon.leadingAnchor.constraint(equalTo: marginGuide.trailingAnchor, constant: -50).isActive = true
        icon.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor, constant: 0).isActive = true
        icon.contentMode = .scaleAspectFit
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
