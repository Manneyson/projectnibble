//
//  AthleteTableViewCell.swift
//  CFGLive
//
//  Created by Sawyer Billings on 7/6/17.
//  Copyright © 2017 Sawyer Billings. All rights reserved.
//

import UIKit
import ChameleonFramework
import FaveButton

class OrderViewCell: UITableViewCell {
    
    //var address: UILabel!
    var orderDetails: UILabel!
    var price: UILabel!
    var restaurant: UILabel!
    var cancel: UIButton!
    var status: UIImageView!
    
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
        
        
        restaurant = UILabel()
        restaurant.frame = CGRect(x: gap, y: gap, width: labelWidth, height: labelHeight)
        restaurant.textColor = UIColor.white
        restaurant.font =  UIFont(name: "Avenir-Book", size: 17)
        contentView.addSubview(restaurant)
        
        orderDetails = UILabel()
        orderDetails.frame = CGRect(x: gap, y: gap * 3, width: labelWidth, height: labelHeight * 4)
        orderDetails.textColor = UIColor.white
        orderDetails.numberOfLines = 5
        orderDetails.font =  UIFont(name: "Avenir-Book", size: 13)
        contentView.addSubview(orderDetails)
        
        /*
        address = UILabel()
        address.frame = CGRect(x: gap, y: gap * 5, width: labelWidth, height: labelHeight)
        address.textColor = UIColor.white
        address.font =  UIFont(name: "Avenir-Book", size: 13)
        contentView.addSubview(address)
        */
        price = UILabel()
        price.frame = CGRect(x: UIScreen.main.bounds.width - (bounds.height * 1.5) - 50, y: bounds.height / 2, width: bounds.height * 1.25, height: bounds.height * 1.25)
        price.layer.cornerRadius = (bounds.height * 1.25) / 2
        price.layer.masksToBounds = true
        price.backgroundColor = UIColor.flatMint()
        price.font = UIFont(name: "Avenir-Book", size: 13)
        price.textColor = UIColor.flatWhite()
        price.textAlignment = .center
        contentView.addSubview(price)
        
        status = UIImageView()
        status.frame = CGRect(x: UIScreen.main.bounds.width - (bounds.height * 1.5) - 39, y: bounds.height + (bounds.height * 1.2), width: bounds.height * 0.75, height: bounds.height * 0.75)
        contentView.addSubview(status)
        
        
        /// Cancellation button to be implemented later
        /*
        cancel = UIButton()
        cancel.frame = CGRect(x: UIScreen.main.bounds.width - (bounds.height * 1.5) - 100, y: bounds.height / 2, width: bounds.height * 1.25, height: bounds.height * 1.25)
        cancel.setImage(UIImage(named: "cancel"), for: .normal)
        contentView.addSubview(cancel)
        */
        
    }
    
}
