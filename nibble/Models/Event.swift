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
        
    init(title: String, restaurant: String) {
        self.title = title
    }
}
