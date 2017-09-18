//
//  Item.swift
//  Pods
//
//  Created by Sawyer Billings on 9/16/17.
//
//

import Foundation

class Item {
    
    var name: String
    var price: Int
    var size: String
    var quantity: Int
    var index: IndexPath
    
    init(name: String, price: Int, size: String, quantity: Int, index: IndexPath) {
        self.name = name
        self.price = price
        self.size = size
        self.quantity = quantity
        self.index = index
    }
    
}

