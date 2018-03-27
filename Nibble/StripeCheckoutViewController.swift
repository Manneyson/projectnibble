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
    var customerId = ""
    var totalCost: Int?
    var order: Order?
    var lastFourDigits = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkout.addTarget(self, action: #selector(checkoutPressed(sender:)), for: .touchUpInside)
        quickPay.addTarget(self, action: #selector(quickPayPressed(sender:)), for: .touchUpInside)
        close.addTarget(self, action: #selector(closePressed(sender:)), for: .touchUpInside)
        subtotal.text = "\(order?.total)".currencyInputFormatting()
        tip.text = "\(order?.tip)".currencyInputFormatting()
        totalCost = Int((order?.total)!) + Int((order?.tip)!)
        total.text = "\(totalCost)".currencyInputFormatting()
        
        navigationController?.navigationBar.isHidden = true
        
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
            self.customerId = value ?? ""
            if (self.customerId != "") {
                self.getExistingCustomerCards()
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func getExistingCustomerCards() {
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
                    self.lastFourDigits = value
                    self.updateButtonText()
                case .failure(let error):
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
    
    @objc func closePressed(sender: UIButton?) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func quickPayPressed(sender: UIButton?) {
        if (customerId != "0") {
            // 1
            let endpoint = Constants.baseURLString + "/charge"
            let url = URL(string: endpoint)
            
            // 2
            let params: [String: Any] = [
                "amount": totalCost,
                "currency": Constants.defaultCurrency,
                "customer": customerId,
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
                                     "subtotal": self.order?.total,
                                     "tip": self.order?.tip,
                                     "restaurant": self.order?.restaurant.name,
                                     "organization": self.order?.organization.name,
                                     "donation": self.order?.donation,
                                     "status": "placed"
                            ] as [String : Any]
                        
                        newOrder.child(key).setValue(order)
                        
                        //alert user of success!
                        let alertController = UIAlertController(title: "Congrats",
                                                                message: "Your payment was successful!",
                                                                preferredStyle: .alert)
                        let alertAction = UIAlertAction(title: "OK", style: .default, handler: { _ in
                            self.navigationController?.popViewController(animated: true)
                        })
                        alertController.addAction(alertAction)
                        self.present(alertController, animated: true)

                    case .failure(let error):
                        let alertController = UIAlertController(title: "Fail!",
                                                                message: "Your payment did not work!",
                                                                preferredStyle: .alert)
                        let alertAction = UIAlertAction(title: "OK", style: .default, handler: { _ in
                            self.navigationController?.popViewController(animated: true)
                        })
                        alertController.addAction(alertAction)
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
        StripeClient.shared.completeCharge(with: token, amount: totalCost!, customer: self.customerId) { result in
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
                    self.navigationController?.popViewController(animated: true)
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
 
