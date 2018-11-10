//
//  Restaurant.swift
//  Nibble
//
//  Created by Sawyer Billings on 10/17/17.
//  Copyright © 2017 Sawyer Billings. All rights reserved.
//

import Foundation

struct Restaurant: Codable, Equatable {
    let id: String
    let name: String
    let pledge: Double
    let stripe: String
    let icon: String
    
    init(id: String, name: String, pledge: Double, icon: String, stripe: String) {
        self.id = id
        self.name = name
        self.pledge = pledge
        self.stripe = stripe
        self.icon = icon
    }
}
