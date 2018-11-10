//
//  API.swift
//  nibble
//
//  Created by Sawyer Billings on 10/26/18.
//  Copyright © 2018 sbilling. All rights reserved.
//

import Foundation
import Firebase
import CodableFirebase

class API {
    
    static let shared = API()
    let db = Firestore.firestore()
    
    private init() {}
    
    func loadEvents(eventArray: @escaping ([Event]) -> Void) {
        Data.sharedInstance.events = []
        db.collection("events").addSnapshotListener { documentSnapshot, error in
            guard let attempt = documentSnapshot else {
                print("Error fetching document: \(error!)")
                return
            }
            
            for document in attempt.documents {
                let model = try! FirestoreDecoder().decode(Event.self, from: document.data())
                if (!Data.sharedInstance.events.contains(model)) {
                    Data.sharedInstance.events.append(model)
                }
            }
            
            eventArray(Data.sharedInstance.events)
        }
    }
    
    func loadRestaurants(eventArray: @escaping ([Restaurant]) -> Void) {
        Data.sharedInstance.restaurants = []
        db.collection("restaurants").addSnapshotListener { documentSnapshot, error in
            guard let attempt = documentSnapshot else {
                print("Error fetching document: \(error!)")
                return
            }
            
            for document in attempt.documents {
                let model = try! FirestoreDecoder().decode(Restaurant.self, from: document.data())
                if (!Data.sharedInstance.restaurants.contains(model)) {
                    Data.sharedInstance.restaurants.append(model)
                }
            }
            
            eventArray(Data.sharedInstance.restaurants)
        }
    }
    
    func loadOrganizations(eventArray: @escaping ([Organization]) -> Void) {
        Data.sharedInstance.organizations = []
        db.collection("organizations").addSnapshotListener { documentSnapshot, error in
            guard let attempt = documentSnapshot else {
                print("Error fetching document: \(error!)")
                return
            }
            
            for document in attempt.documents {
                let model = try! FirestoreDecoder().decode(Organization.self, from: document.data())
                if (!Data.sharedInstance.organizations.contains(model)) {
                    Data.sharedInstance.organizations.append(model)
                }
            }
            
            eventArray(Data.sharedInstance.organizations)
        }
    }
    
}
