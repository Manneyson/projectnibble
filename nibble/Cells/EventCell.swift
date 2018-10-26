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
        
        title.translatesAutoresizingMaskIntoConstraints = false
        title.topAnchor.constraint(equalTo: marginGuide.topAnchor, constant: 0).isActive = true
        title.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor, constant: 0).isActive = true
        title.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor, constant: -50).isActive = true
        title.textColor = UIColor.black
        title.font = UIFont(name: "Avenir-Heavy", size: 24)
        title.numberOfLines = 0
        
        date.translatesAutoresizingMaskIntoConstraints = false
        date.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 10).isActive = true
        date.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor, constant: 0).isActive = true
        date.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor, constant: -100).isActive = true
        date.textColor = UIColor.black
        date.font = UIFont(name: "Avenir", size: 14)
        date.numberOfLines = 0
        
        venue.translatesAutoresizingMaskIntoConstraints = false
        venue.topAnchor.constraint(equalTo: marginGuide.topAnchor, constant: 10).isActive = true
        venue.leadingAnchor.constraint(equalTo: title.trailingAnchor, constant: 0).isActive = true
        venue.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor, constant: 20).isActive = true
        venue.textAlignment = .center
        venue.textColor = UIColor.black
        venue.font = UIFont(name: "Avenir-Heavy", size: 14)
        venue.numberOfLines = 0
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

