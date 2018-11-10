//
//  Event.swift
//  nibble
//
//  Created by Sawyer Billings on 10/26/18.
//  Copyright © 2018 sbilling. All rights reserved.
//

import Foundation

struct Event: Codable, Equatable {
    
    let title: String
    let restaurant: String
    let organization: String
    let date: String
    
    init(title: String, restaurant: String, organization: String, date: String) {
        self.title = title
        self.restaurant = restaurant
        self.organization = organization
        self.date = date
    }
}
