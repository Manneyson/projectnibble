//
//  BackendAPIAdapter.swift
//  Standard Integration (Swift)
//
//  Created by Ben Guo on 4/15/16.
//  Copyright © 2016 Stripe. All rights reserved.
//

import Foundation
import Stripe
import Alamofire
import Firebase
import SwiftyJSON


class MyAPIClient: NSObject, STPEphemeralKeyProvider {

    static let sharedClient = MyAPIClient()
    var baseURLString: String? = nil
    var baseURL: URL {
        if let urlString = self.baseURLString, let url = URL(string: urlString) {
            return url
        } else {
            fatalError()
        }
    }

    func completeCharge(_ result: STPPaymentResult,
                        amount: Int,
                        orgAmount: Int,
                        restAmount: Int,
                        description: String,
                        restaurant: String,
                        organization: String,
                        shippingAddress: STPAddress?,
                        shippingMethod: PKShippingMethod?,
                        completion: @escaping STPErrorBlock) {
        let url = self.baseURL.appendingPathComponent("charge")
        var params: [String: Any] = [
            "description": description,
            "source": result.source.stripeID,
            "amount": amount,
            "rest_amount": restAmount,
            "org_amount": orgAmount,
            "restaurant_id": restaurant,
            "organization_id": organization,
        ]
        params["shipping"] = STPAddress.shippingInfoForCharge(with: shippingAddress, shippingMethod: shippingMethod)
        Alamofire.request(url, method: .post, parameters: params)
            .validate(statusCode: 200..<300)
            .responseString { response in
                switch response.result {
                case .success:
                    completion(nil)
                case .failure(let error):
                    completion(error)
                }
        }
    }

    func createCustomerKey(withAPIVersion apiVersion: String, completion: @escaping STPJSONResponseCompletionBlock) {
        let url = self.baseURL.appendingPathComponent("ephemeral_keys")
        let userID = Auth.auth().currentUser?.uid
        var id = ""
        Database.database().reference().child("Users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? String
            id = value!
        }) { (error) in
            print(error.localizedDescription)
        }
        print(id)
        Alamofire.request(url, method: .post, parameters: [
            "api_version": apiVersion,
            "customer_id": id
            ])
            
            .validate(statusCode: 200..<300)
            .responseJSON { responseJSON in
                switch responseJSON.result {
                case .success(let json):
//                    let payload = JSON(json)
//                    let customerKey = payload["associated_objects"][0]["id"].stringValue
//                    print(customerKey)
//                    print(payload)
//                    Database.database().reference().child("Users").child((Auth.auth().currentUser?.uid)!).setValue(customerKey)
                    completion(json as? [String: AnyObject], nil)
                case .failure(let error):
                    completion(nil, error)
                }
        }
    }

}
