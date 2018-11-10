//
//  StripeClient.swift
//  Nibble
//
//  Created by Sawyer Billings on 2/11/18.
//  Copyright © 2018 Nibble. All rights reserved.
//

import Foundation
import Alamofire
import Stripe
import Firebase

enum Result {
    case success
    case failure(Error)
}

final class StripeClient {
    
    static let shared = StripeClient()
    
    private init() {
        // private
    }
    
    private lazy var baseURL: URL = {
        guard let url = URL(string: Constants.baseURLString) else {
            fatalError("Invalid URL")
        }
        return url
    }()
    
    func completeCharge(with token: STPToken, amount: Int, org_stripe: String, rest_stripe: String, completion: @escaping (Result) -> Void) {
        
        let url = baseURL.appendingPathComponent("/charge")
        
        let params: [String: Any] = [
            "token": token.tokenId,
            "amount": amount,
            "currency": Constants.defaultCurrency,
            "description": Constants.defaultDescription,
            "email": Auth.auth().currentUser?.email ?? "",
            "userID": UIDevice.current.identifierForVendor!.uuidString,
            "org_stripe": org_stripe,
            "rest_stripe": rest_stripe,
            "transfer": String.random(),
        ]
        print(params)

        Alamofire.request(url, method: .post, parameters: params)
            .validate(statusCode: 200..<300)
            .responseString { response in
                switch response.result {
                case .success:
                    completion(Result.success)
                case .failure(let error):
                    completion(Result.failure(error))
                }
        }
    }
}
