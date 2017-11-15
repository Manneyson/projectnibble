//
//  Organization.swift
//  Nibble
//
//  Created by Sawyer Billings on 10/9/17.
//  Copyright © 2017 Sawyer Billings. All rights reserved.
//

import Foundation

struct Organization {
    let name: String
    let info: String
    let icon: String
    let stripe: String
    
    init(name: String, info: String, icon: String, stripe: String) {
        self.name = name
        self.info = info
        self.icon = icon
        self.stripe = stripe
    }
}
