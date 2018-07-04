//
//  StripeCheckoutViewController
//  Standard Integration (Swift)
//
//  Created by Sawyer Billings
//  Copyright © 2018
//

import UIKit
import Stripe
import Firebase
import Alamofire
import SwiftyJSON

class StripeCheckoutViewController: UIViewController {
    
    @IBOutlet weak var close: UIButton!
    @IBOutlet weak var quickPay: UIButton!
    @IBOutlet weak var checkout: UIButton!
    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var tip: UILabel!
    @IBOutlet weak var subtotal: UILabel!
    var customerId = "0"
    var totalCost: Double?
    var restaurantAmount: Double = 0
    var order: Order?
    var lastFourDigits = ""
    var donationAmount: Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkout.addTarget(self, action: #selector(applePayPressed(sender:)), for: .touchUpInside)
        quickPay.addTarget(self, action: #selector(quickPayPressed(sender:)), for: .touchUpInside)
        close.addTarget(self, action: #selector(closePressed(sender:)), for: .touchUpInside)
        subtotal.text = "\(order?.total)".currencyInputFormatting()
        tip.text = "\(order?.tip)".currencyInputFormatting()
        totalCost = Double((order?.total)!) + Double((order?.tip)!)
        total.text = "\(totalCost! / 10.0)".currencyInputFormatting()
        
        navigationController?.navigationBar.isHidden = true
        
        let nibbleFee = totalCost! * 0.02 //2% Nibble fee
        
        //calculate transfers for restaurant and organization
        restaurantAmount = totalCost! - (totalCost! * 0.029) - 30 - ((self.order?.restaurant.pledge)! * totalCost!) - nibbleFee
        donationAmount = (self.order?.restaurant.pledge)! * totalCost!
        
        getExistingCustomer()
    }
    
    func updateButtonText() {
        if lastFourDigits != "" {
            quickPay.setTitle("Pay With Card \(lastFourDigits)", for: .normal)
            quickPay.setTitleColor(UIColor.white, for: .normal)
            quickPay.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 17.0)
        }
    }
    
    func getExistingCustomer() {
        Database.database().reference().child("Users").child(UIDevice.current.identifierForVendor!.uuidString).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? String
            self.customerId = value ?? "0"
            if (self.customerId != "0") {
                self.getExistingCustomerCards()
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func getExistingCustomerCards() {
        let hud = HUD.showLoading()
        // 1
        let endpoint = Constants.baseURLString + "/retrieve_cards"
        let url = URL(string: endpoint)
        // 2
        let params: [String: Any] = [
            "customer": self.customerId
            ]
        print(params)
        // 3
        Alamofire.request(url!, method: .get, parameters: params)
            .validate(statusCode: 200..<300)
            .responseString { response in
                switch response.result {
                case .success(let value):
                    hud.dismiss()
                    self.lastFourDigits = value
                    self.updateButtonText()
                case .failure(let error):
                    hud.dismiss()
                    print(error.localizedDescription)
                    print("nothing retrieved")
                }
        }
    }
    
    @objc func checkoutPressed(sender: UIButton?) {
        let addCardViewController = STPAddCardViewController()
        addCardViewController.delegate = self
        navigationController?.navigationBar.isHidden = false
        navigationController?.pushViewController(addCardViewController, animated: true)
    }
    
    @objc func applePayPressed(sender: UIButton?) {
        let merchantIdentifier = "merchant.com.ProjectNibble"
        let paymentRequest = Stripe.paymentRequest(withMerchantIdentifier: merchantIdentifier, country: "US", currency: "USD")
        
        // Configure the line items on the payment request
        let cost = (self.totalCost! / 100.0)
        let price = NSDecimalNumber(value: cost)
        paymentRequest.paymentSummaryItems = [
            PKPaymentSummaryItem(label: "Order Total", amount: price),
            
            // The final line should represent your company;
            // it'll be prepended with the word "Pay" (i.e. "Pay iHats, Inc $50")
            PKPaymentSummaryItem(label: "Nibble", amount: price),
        ]
        
        if Stripe.canSubmitPaymentRequest(paymentRequest) {
            // Setup payment authorization view controller
            let paymentAuthorizationViewController = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest)
            paymentAuthorizationViewController.delegate = self
            
            // Present payment authorization view controller
            present(paymentAuthorizationViewController, animated: true)
        }
        else {
            // There is a problem with your Apple Pay configuration
            print("welp that did not work!")
        }
    }
    
    @objc func closePressed(sender: UIButton?) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func quickPayPressed(sender: UIButton?) {
        let hud = HUD.showLoading()
        if (customerId != "0") {
            // 1
            let endpoint = Constants.baseURLString + "/charge"
            let url = URL(string: endpoint)
            
            // 2
            let params: [String: Any] = [
                "amount": totalCost ?? 0,
                "currency": Constants.defaultCurrency,
                "customer": customerId,
                "org_stripe": self.order?.organization.stripe ?? "nil",
                "rest_stripe": self.order?.restaurant.stripe ?? "nil",
                "donation_amount": Int(self.donationAmount),
                "restaurant_amount": Int(restaurantAmount) ?? 0,
                "transfer": String.random(),
            ]
            print(params)
            // 3
            Alamofire.request(url!, method: .post, parameters: params)
                .validate(statusCode: 200..<300)
                .responseString { response in
                    switch response.result {
                    case .success:
                        //write the payment to the social feed
                        let newOrder = Database.database().reference().child("orders")
                        let key = newOrder.childByAutoId().key
                        
                        
                        let order = ["id": Auth.auth().currentUser?.uid ?? "nil user",
                                     "email": Auth.auth().currentUser?.email ?? "nil email",
                                     "subtotal": self.order?.total ?? 0,
                                     "tip": self.order?.tip ?? 0,
                                     "restaurant": self.order?.restaurant.name ?? "nil",
                                     "organization": self.order?.organization.name ?? "nil",
                                     "donation": self.order?.donation,
                                     "status": "placed"
                            ] as [String : Any]
                        
                        newOrder.child(key).setValue(order)
                        
                        //alert user of success!
                        let alertController = UIAlertController(title: "Congrats",
                                                                message: "Your payment was successful!",
                                                                preferredStyle: .alert)
                        let alertAction = UIAlertAction(title: "OK", style: .default, handler: { _ in
                            self.navigationController?.dismiss(animated: true)
                        })
                        alertController.addAction(alertAction)
                        hud.dismiss()
                        self.present(alertController, animated: true)
                    case .failure(let error):
                        let alertController = UIAlertController(title: "Fail!",
                                                                message: "Your payment did not work!",
                                                                preferredStyle: .alert)
                        let alertAction = UIAlertAction(title: "OK", style: .default, handler: { _ in
                            self.navigationController?.dismiss(animated: true)
                        })
                        alertController.addAction(alertAction)
                        hud.dismiss()
                        self.present(alertController, animated: true)
                    }
            }
        }
    }
}

extension StripeCheckoutViewController: STPAddCardViewControllerDelegate {
    
    func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func addCardViewController(_ addCardViewController: STPAddCardViewController,
                               didCreateToken token: STPToken,
                               completion: @escaping STPErrorBlock) {
        StripeClient.shared.completeCharge(with: token, amount: totalCost!, donation: donationAmount, restaurantAmount: restaurantAmount, customer: self.customerId, org_stripe: (self.order?.organization.stripe)!, rest_stripe: (self.order?.restaurant.stripe)!) { result in
            switch result {
            // 1
            case .success:
                completion(nil)
                //write the order to firebase
                let newOrder = Database.database().reference().child("orders")
                let key = newOrder.childByAutoId().key
                
                
                let order = ["id": Auth.auth().currentUser?.uid ?? "nil user",
                             "email": Auth.auth().currentUser?.email ?? "nil email",
                             "subtotal": self.order?.total,
                             "tip": self.order?.tip,
                             "restaurant": self.order?.restaurant.name,
                             "organization": self.order?.organization.name,
                             "donation": self.order?.donation,
                             "status": "placed"
                    ] as [String : Any]
                
                newOrder.child(key).setValue(order)
                
                //tell user it worked
                let alertController = UIAlertController(title: "Congrats",
                                                        message: "Your payment was successful!",
                                                        preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "OK", style: .default, handler: { _ in
                    self.navigationController?.dismiss(animated: true)
                })
                alertController.addAction(alertAction)
                self.present(alertController, animated: true)
            // 2
            case .failure(let error):
                completion(error)
            }
        }
    }
}

//apple pay extension

extension StripeCheckoutViewController: PKPaymentAuthorizationViewControllerDelegate {

    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, completion: @escaping (PKPaymentAuthorizationStatus) -> Void) {
        STPAPIClient.shared().createToken(with: payment) { (token: STPToken?, error: Error?) in
            guard let token = token, error == nil else {
                // Present error to user...
                print("error creating token")
                return
            }
            StripeClient.shared.completeCharge(with: token, amount: self.totalCost!, donation: self.donationAmount, restaurantAmount: self.restaurantAmount, customer: self.customerId, org_stripe: (self.order?.organization.stripe)!, rest_stripe: (self.order?.restaurant.stripe)!) { result in
                switch result {
                // 1
                case .success:
                    completion(PKPaymentAuthorizationStatus.success)
                    //write the order to firebase
                    let newOrder = Database.database().reference().child("orders")
                    let key = newOrder.childByAutoId().key
                    
                    
                    let order = ["id": Auth.auth().currentUser?.uid ?? "nil user",
                                 "email": Auth.auth().currentUser?.email ?? "nil email",
                                 "subtotal": self.order?.total,
                                 "tip": self.order?.tip,
                                 "restaurant": self.order?.restaurant.name,
                                 "organization": self.order?.organization.name,
                                 "donation": self.order?.donation,
                                 "status": "placed"
                        ] as [String : Any]
                    
                    newOrder.child(key).setValue(order)
                    
                    //tell user it worked
                    let alertController = UIAlertController(title: "Congrats",
                                                            message: "Your payment was successful!",
                                                            preferredStyle: .alert)
                    let alertAction = UIAlertAction(title: "OK", style: .default, handler: { _ in
                        self.navigationController?.dismiss(animated: true)
                    })
                    alertController.addAction(alertAction)
                    self.present(alertController, animated: true)
                // 2
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

extension String {
    
    static func random(length: Int = 20) -> String {
        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString: String = ""
        
        for _ in 0..<length {
            let randomValue = arc4random_uniform(UInt32(base.count))
            randomString += "\(base[base.index(base.startIndex, offsetBy: Int(randomValue))])"
        }
        return randomString
    }
}

