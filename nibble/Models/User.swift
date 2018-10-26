//
//  User.swift
//  nibble
//
//  Created by Sawyer Billings on 10/17/17.
//  Copyright © 2017 Sawyer Billings. All rights reserved.
//

import Foundation

class User {
    let uid: String
    let email: String
    let customerId: String

    init(authData: User) {
        uid = authData.uid
        email = authData.email
        customerId = authData.customerId
    }

    init(uid: String, email: String, customerId: String) {
        self.uid = uid
        self.email = email
        self.customerId = customerId
    }
}
