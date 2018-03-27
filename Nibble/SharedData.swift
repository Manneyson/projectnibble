//
//  SharedData.swift
//  Nibble
//
//  Created by Sawyer Billings on 3/26/18.
//  Copyright © 2018 Sawyer Billings. All rights reserved.
//

import Foundation
import Firebase

class SharedData {
    static let sharedInstance = SharedData()
    var organizations: [Organization] = []
    var restaurants: [Restaurant] = []
    
    func loadOrganizations() {
            let organizations = Database.database().reference().child("organizations")
            organizations.observe(DataEventType.value, with: { (snapshot) in
                if (snapshot.childrenCount > 0) {
                    for entries in snapshot.children.allObjects as! [DataSnapshot] {
                        let spot = entries.value as? [String: AnyObject]
                        self.organizations.append(Organization(name: spot?["name"] as! String, info: spot?["info"] as! String, icon: spot?["icon"] as! String, stripe: spot?["stripe"] as! String, url: spot?["url"] as! String))
                }
            }
        })
    }
    
    func loadRestaurants() {
        let spots = Database.database().reference().child("restaurants")
        spots.observe(DataEventType.value, with: { (snapshot) in
            if (snapshot.childrenCount > 0) {
                for entries in snapshot.children.allObjects as! [DataSnapshot] {
                    let spot = entries.value as? [String: AnyObject]
                    self.restaurants.append(Restaurant(name: spot?["name"] as! String, pledge: spot?["pledge"] as! Double, stripe: spot?["stripe"] as! String, open: spot?["open"] as! Int, close: spot?["close"] as! Int, icon: spot?["icon"] as! String, info: spot?["info"] as! String, header: spot?["header"] as! String))
                }
            }
        })
    }
}
