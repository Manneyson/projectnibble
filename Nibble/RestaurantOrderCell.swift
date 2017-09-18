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

class RestaurantOrderCell: UITableViewCell {
    
    var address1: UILabel!
    var address2: UILabel!
    var city: UILabel!
    var phone: UILabel!
    var price: UILabel!
    var type: UILabel!
    var cancel: UIButton!
    var orderDetails: UILabel!
    var orderStatus: UIImageView!
    
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
        
        
        type = UILabel()
        type.frame = CGRect(x: gap, y: gap, width: labelWidth, height: labelHeight)
        type.textColor = UIColor.flatBlack()
        type.font =  UIFont(name: "Avenir-Book", size: 17)
        contentView.addSubview(type)
        
        orderDetails = UILabel()
        orderDetails.frame = CGRect(x: gap, y: gap + (gap/2), width: labelWidth, height: labelHeight * 4)
        orderDetails.numberOfLines = 7
        orderDetails.textColor = UIColor.flatBlack()
        orderDetails.font =  UIFont(name: "Avenir-Book", size: 14)
        contentView.addSubview(orderDetails)
        
        orderStatus = UIImageView()
        orderStatus.frame = CGRect(x: gap/2, y: gap * 16, width: labelHeight, height: labelHeight)
        contentView.addSubview(orderStatus)
        
        
        
        address1 = UILabel()
        address1.frame = CGRect(x: UIScreen.main.bounds.width - 220, y: gap * 6, width: labelWidth, height: labelHeight)
        address1.textColor = UIColor.flatBlack()
        address1.textAlignment = .right
        address1.font =  UIFont(name: "Avenir-Book", size: 12)
        contentView.addSubview(address1)
        
        address2 = UILabel()
        address2.frame = CGRect(x: UIScreen.main.bounds.width - 220, y: gap * 8, width: labelWidth, height: labelHeight)
        address2.textColor = UIColor.flatBlack()
        address2.textAlignment = .right
        address2.font =  UIFont(name: "Avenir-Book", size: 12)
        contentView.addSubview(address2)
        
        
        city = UILabel()
        city.frame = CGRect(x: UIScreen.main.bounds.width - 220, y: gap * 10, width: labelWidth, height: labelHeight)
        city.textColor = UIColor.flatBlack()
        city.textAlignment = .right
        city.font =  UIFont(name: "Avenir-Book", size: 12)
        contentView.addSubview(city)
        
        phone = UILabel()
        phone.frame = CGRect(x: UIScreen.main.bounds.width - 220, y: gap * 12, width: labelWidth, height: labelHeight)
        phone.textColor = UIColor.flatBlack()
        phone.textAlignment = .right
        phone.font =  UIFont(name: "Avenir-Book", size: 12)
        contentView.addSubview(phone)
        
        price = UILabel()
        price.frame = CGRect(x: UIScreen.main.bounds.width - (bounds.height * 1.5), y: gap, width: bounds.height * 1.25, height: bounds.height * 1.25)
        price.layer.cornerRadius = (bounds.height * 1.25) / 2
        price.layer.masksToBounds = true
        price.backgroundColor = UIColor.flatMint()
        price.font = UIFont(name: "Avenir-Book", size: 13)
        price.textColor = UIColor.flatWhite()
        price.textAlignment = .center
        contentView.addSubview(price)
        
        
        /// Cancellation button to be implemented later
        /*
         cancel = UIButton()
         cancel.frame = CGRect(x: UIScreen.main.bounds.width - (bounds.height * 1.5) - 100, y: bounds.height / 2, width: bounds.height * 1.25, height: bounds.height * 1.25)
         cancel.setImage(UIImage(named: "cancel"), for: .normal)
         contentView.addSubview(cancel)
         */
        
    }
    
}
