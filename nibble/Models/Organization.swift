//
//  Organization.swift
//  Nibble
//
//  Created by Sawyer Billings on 10/9/17.
//  Copyright © 2017 Sawyer Billings. All rights reserved.
//

import Foundation

struct Organization: Codable, Equatable {
    let id: String
    let name: String
    let info: String
    let icon: String
    let stripe: String
    let url: String
    
    init(id: String, name: String, info: String, icon: String, stripe: String, url: String) {
        self.id = id
        self.name = name
        self.info = info
        self.icon = icon
        self.stripe = stripe
        self.url = url
    }
}
