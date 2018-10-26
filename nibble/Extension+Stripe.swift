//Stripe Apple Pay Extension
import Stripe

extension OrderViewController: PKPaymentAuthorizationViewControllerDelegate {
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, completion: @escaping (PKPaymentAuthorizationStatus) -> Void) {
        STPAPIClient.shared().createToken(with: payment) { (token: STPToken?, error: Error?) in
            guard let token = token, error == nil else {
                // Present error to user...
                print("error creating token")
                return
            }
            StripeClient.shared.completeCharge(with: token, amount: 100, donation: 50, restaurantAmount: 10, org_stripe: "acct_17Qh64FJqdn47PNo", rest_stripe: self.restaurant?.stripe ?? "nil") { result in
                switch result {
                case .success:
                    completion(PKPaymentAuthorizationStatus.success)
                    let alertController = UIAlertController(title: "Congrats",
                                                            message: "Your payment was successful!",
                                                            preferredStyle: .alert)
                    let alertAction = UIAlertAction(title: "OK", style: .default, handler: { _ in
                        self.dismiss(animated: true)
                    })
                    alertController.addAction(alertAction)
                    self.present(alertController, animated: true)
                case .failure(let error):
                    completion(PKPaymentAuthorizationStatus.failure)
                }
            }
        }
    }
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        // Dismiss payment authorization view controller
        dismiss(animated: true, completion: nil)
    }
}
