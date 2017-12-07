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
        
        contentView.backgroundColor = UIColor.clear
        backgroundView = UIImageView(image: UIImage(named: "cellbg")!)
        
        let gap : CGFloat = 10
        let labelHeight: CGFloat = 30
        let labelWidth: CGFloat = frame.width * 0.65
        let lineGap : CGFloat = 5
        let label2Y : CGFloat = gap + labelHeight + lineGap
        
        
        myLabel1 = UILabel()
        myLabel1.frame = CGRect(x: gap * 3, y: gap * 2, width: labelWidth, height: labelHeight)
        myLabel1.textColor = UIColor.black
        myLabel1.font =  UIFont(name: "Avenir-Book", size: 17)
        contentView.addSubview(myLabel1)
        
        profile = UIImageView()
        profile.image = UIImage()
        profile.frame = CGRect(x: UIScreen.main.bounds.width - (bounds.height * 2.3), y: bounds.height / 2, width: bounds.height * 1.5, height: bounds.height * 1.5)
        profile.layer.cornerRadius = (bounds.height * 1.25) / 2
        profile.layer.masksToBounds = true
        profile.contentMode = UIViewContentMode.scaleAspectFit

        contentView.addSubview(profile)
        
        menu = UIButton()
        menu.frame = CGRect(x: UIScreen.main.bounds.width - (bounds.height * 2.3), y: (bounds.height * 3), width: bounds.height * 1.5, height: 30)
        menu.layer.cornerRadius = 6
        menu.layer.masksToBounds = true
        menu.backgroundColor = UIColor(patternImage: UIImage(named: "menu bg2")!)
        menu.setTitle("Pay", for: .normal)
        menu.titleLabel!.font = UIFont(name: "Avenir-Book", size: 13)
        contentView.addSubview(menu)
        
    }
    
//    override var frame: CGRect {
//        get {
//            return super.frame
//        }
//        set (newFrame) {
//            var frame = newFrame
//            frame = CGRect(x: 10, y: super.frame.origin.y, width: super.frame.width - 10, height: super.frame.height)
//            super.frame = frame
//        }
//    }
    
}
