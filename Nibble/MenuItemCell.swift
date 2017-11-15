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
import GMStepper

class MenuItemCell: UITableViewCell {
    
    var myLabel1: UILabel!
    var price: UIButton!
    //var profile: UIImageView!
    var order: UIButton!
    //var faveButton: FaveButton!
    var addButton: UIButton!
    var details: UILabel!
    var smallLabel: UILabel!
    var attributes: [[Int]]!
    var cost: Int!
    var quantity: UIButton!
    var quantityLabel: UILabel!
    
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
        myLabel1.frame = CGRect(x: gap * 3.5, y: gap, width: labelWidth, height: labelHeight)
        myLabel1.textColor = UIColor.black
        myLabel1.font =  UIFont(name: "Avenir-Book", size: 15)
        contentView.addSubview(myLabel1)
        
        details = UILabel()
        details.frame = CGRect(x: gap * 3.5, y: super.frame.height / 2, width: labelWidth, height: labelHeight * 3)
        details.textColor = UIColor.gray
        details.font = UIFont(name: "Avenir-Book", size: 10)
        details.lineBreakMode = .byWordWrapping;
        details.numberOfLines = 4;
        contentView.addSubview(details)
        
        price = UIButton()
        price.frame = CGRect(x: UIScreen.main.bounds.width - (bounds.height * 1.9), y: bounds.height / 2, width: bounds.height * 1.25, height: bounds.height * 1.25)
        price.layer.cornerRadius = (bounds.height * 1.25) / 2
        price.layer.masksToBounds = true
        price.backgroundColor = UIColor.black
        price.titleLabel!.font =  UIFont(name: "Avenir-Book", size: 10)
        price.titleLabel?.textAlignment = .center
        price.titleLabel?.numberOfLines = 3
        contentView.addSubview(price)
        
        order = UIButton()
        order.frame = CGRect(x: UIScreen.main.bounds.width - (bounds.height * 1.8), y: (bounds.height * 2), width: bounds.height * 1.25, height: bounds.height * 1.25)
        order.layer.cornerRadius = (bounds.height * 1.25) / 2
        order.layer.masksToBounds = true
        order.backgroundColor = UIColor(patternImage: UIImage(named: "menu bg2")!)
        order.setTitle("Add", for: .normal)
        order.titleLabel!.font =  UIFont(name: "Avenir-Book", size: 13)
        //contentView.addSubview(order)
        
        
        addButton = UIButton()
        addButton.frame = CGRect(x: UIScreen.main.bounds.width - (bounds.height * 1.9), y: (bounds.height * 2), width: bounds.height * 1.25, height: bounds.height * 1.25)
        addButton.setImage(UIImage(named: "icons8-add_filled"), for: .normal)
        contentView.addSubview(addButton)
        
        
        quantity = UIButton()
        quantity.frame = CGRect(x: UIScreen.main.bounds.width - (bounds.height * 1.8) - 50, y: (bounds.height * 2), width: bounds.height * 1.25, height: bounds.height * 1.25)
        quantity.setImage(UIImage(named: "icons8-add-1"), for: .normal)
        contentView.addSubview(quantity)
        
        quantityLabel = UILabel()
        quantityLabel.frame = CGRect(x: UIScreen.main.bounds.width - (bounds.height * 1.8) - 30, y: bounds.height / 2, width: bounds.height * 1.25, height: bounds.height * 1.25)
        quantityLabel.font = UIFont(name: "Avenir-Book", size: 13)
        contentView.addSubview(quantityLabel)

        
        
        
        /*
        faveButton = FaveButton(
            frame: CGRect(x: UIScreen.main.bounds.width - (bounds.height * 1.5), y: (bounds.height * 2), width: bounds.height * 1.25, height: bounds.height * 1.25),
            faveIconNormal: UIImage(named: "heart")
        )
        faveButton.selectedColor = UIColor.flatMint()
        faveButton.delegate = self
        contentView.addSubview(faveButton)
        */
        
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
