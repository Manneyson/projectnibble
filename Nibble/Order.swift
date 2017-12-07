//
//  Order.swift
//  Nibble
//
//  Created by Sawyer Billings on 11/19/17.
//  Copyright © 2017 Sawyer Billings. All rights reserved.
//

import Foundation

class Order {
    
    var email: String
    var restaurant: Restaurant
    var organization: Organization
    var total: String
    
    init(email: String, restaurant: Restaurant, organization: Organization, total: String) {
        self.email = email
        self.restaurant = restaurant
        self.organization = organization
        self.total = total
    }
    
}