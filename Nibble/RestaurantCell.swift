//
//  AthleteTableViewCell.swift
//  CFGLive
//
//  Created by Sawyer Billings on 7/6/17.
//  Copyright © 2017 Sawyer Billings. All rights reserved.
//

import UIKit

class RestaurantCell: UITableViewCell {
    
    var myLabel1: UILabel!
    var delivery: UILabel!
    var profile: UIImageView!
    var menu: UIButton!
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let gap : CGFloat = 10
        let labelHeight: CGFloat = 30
        let labelWidth: CGFloat = frame.width * 0.65
        let lineGap : CGFloat = 5
        let label2Y : CGFloat = gap + labelHeight + lineGap
        
        
        myLabel1 = UILabel()
        myLabel1.frame = CGRect(x: gap, y: gap, width: labelWidth, height: labelHeight)
        myLabel1.textColor = UIColor.black
        myLabel1.font =  UIFont(name: "Avenir-Book", size: 15)
        contentView.addSubview(myLabel1)
        
        /*
        delivery = UILabel()
        delivery.frame = CGRect(x: gap, y: 100, width: labelWidth, height: labelHeight)
        delivery.textColor = UIColor.green
        delivery.text = "Delivering until 3AM"
        contentView.addSubview(delivery)
         */
        
        profile = UIImageView()
        profile.image = UIImage()
        profile.frame = CGRect(x: UIScreen.main.bounds.width - (bounds.height * 1.5), y: bounds.height / 2, width: bounds.height * 1.25, height: bounds.height * 1.25)
        profile.layer.cornerRadius = (bounds.height * 1.25) / 2
        profile.layer.masksToBounds = true
        profile.contentMode = UIViewContentMode.scaleAspectFit

        contentView.addSubview(profile)
        
        menu = UIButton()
        menu.frame = CGRect(x: UIScreen.main.bounds.width - (bounds.height * 1.5), y: (bounds.height * 2), width: bounds.height * 1.25, height: bounds.height * 1.25)
        menu.layer.cornerRadius = (bounds.height * 1.25) / 2
        menu.layer.masksToBounds = true
        menu.backgroundColor = UIColor(patternImage: UIImage(named: "menu bg2")!)
        menu.setTitle("Menu", for: .normal)
        menu.titleLabel!.font = UIFont(name: "Avenir-Book", size: 13)
        contentView.addSubview(menu)
        
    }
    
}
