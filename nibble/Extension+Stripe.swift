//
//  Stripe Extension
//  nibble
//
//  Created by Sawyer Billings on 10/26/18.
//  Copyright © 2018 sbilling. All rights reserved.

import Stripe

extension OrderViewController: PKPaymentAuthorizationViewControllerDelegate {
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, completion: @escaping (PKPaymentAuthorizationStatus) -> Void) {
        STPAPIClient.shared().createToken(with: payment) { (token: STPToken?, error: Error?) in
            guard let token = token, error == nil else {
                print(error.debugDescription)
                print("error creating token")
                return
            }
            StripeClient.shared.completeCharge(with: token, amount: self.total, org_stripe: self.organization?.stripe ?? "nil", rest_stripe: self.restaurant?.stripe ?? "nil") { result in
                switch result {
                case .success:
                    completion(PKPaymentAuthorizationStatus.success)
                case .failure(let error):
                    print(error)
                    completion(PKPaymentAuthorizationStatus.failure)
                }
            }
        }
    }
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        dismiss(animated: true, completion: nil)
    }
}
