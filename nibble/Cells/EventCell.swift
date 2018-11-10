//
//  EventCell.swift
//  nibble
//
//  Created by Sawyer Billings on 10/26/18.
//  Copyright © 2018 sbilling. All rights reserved.
//

import UIKit

class EventCell: UITableViewCell {
    
    var title = UILabel()
    var venue = UILabel()
    var date = UILabel()
    var icon = UIImageView()
    var restaurant: Restaurant?
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let marginGuide = contentView.layoutMarginsGuide
        
        contentView.addSubview(title)
        contentView.addSubview(venue)
        contentView.addSubview(date)
        contentView.addSubview(icon)
        
        title.translatesAutoresizingMaskIntoConstraints = false
        title.topAnchor.constraint(equalTo: marginGuide.topAnchor, constant: 0).isActive = true
        title.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor, constant: 0).isActive = true
        title.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor, constant: -80).isActive = true
        title.textColor = UIColor.black
        title.font = UIFont(name: "Avenir-Heavy", size: 20)
        title.numberOfLines = 0
        
        venue.translatesAutoresizingMaskIntoConstraints = false
        venue.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 10).isActive = true
        venue.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor, constant: 0).isActive = true
        venue.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor, constant: -80).isActive = true
        venue.textColor = UIColor.black
        venue.font = UIFont(name: "Avenir-Heavy", size: 14)
        venue.numberOfLines = 0
        
        date.translatesAutoresizingMaskIntoConstraints = false
        date.topAnchor.constraint(equalTo: venue.bottomAnchor, constant: 20).isActive = true
        date.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor, constant: 0).isActive = true
        date.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor, constant: 0).isActive = true
        date.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor, constant: -80).isActive = true
        date.textColor = UIColor.black
        date.font = UIFont(name: "Avenir", size: 12)
        date.numberOfLines = 0
        
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.topAnchor.constraint(equalTo: marginGuide.topAnchor, constant: 0).isActive = true
        icon.leadingAnchor.constraint(equalTo: marginGuide.trailingAnchor, constant: -50).isActive = true
        icon.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor, constant: 0).isActive = true
        icon.bottomAnchor.constraint(equalTo: marginGuide.topAnchor, constant: 50).isActive = true
        icon.contentMode = .scaleAspectFit
        icon.layer.borderWidth = 1.5
        icon.layer.masksToBounds = false
        icon.layer.borderColor = Colors.primaryGreen.cgColor
        icon.layer.cornerRadius = 25
        icon.clipsToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

