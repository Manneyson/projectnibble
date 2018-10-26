//
//  Data.swift
//  nibble
//
//  Created by Sawyer Billings on 10/26/18.
//  Copyright © 2018 sbilling. All rights reserved.
//

import Foundation

class Data {
    static let sharedInstance = Data()
    
    var events = [Event]()
    var restaurants = [Restaurant]()
    var organizations = [Organization]()
}
