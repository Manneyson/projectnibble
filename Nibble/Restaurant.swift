//
//  Restaurant.swift
//  Nibble
//
//  Created by Sawyer Billings on 10/17/17.
//  Copyright © 2017 Sawyer Billings. All rights reserved.
//

import Foundation

struct Restaurant {
    let name: String
    let pledge: Double
    let stripe: String
    let open: Int
    let close: Int
    let icon: String
    let info: String
    let header: String
    
    init(name: String, pledge: Double, stripe: String, open: Int, close: Int, icon: String, info: String, header: String) {
        self.name = name
        self.pledge = pledge
        self.stripe = stripe
        self.open = open
        self.close = close
        self.icon = icon
        self.info = info
        self.header = header
    }
}
