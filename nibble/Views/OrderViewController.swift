//
//  OrderViewController.swift
//  nibble
//
//  Created by Sawyer Billings on 10/26/18.
//  Copyright © 2018 sbilling. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialButtons
import Stripe

class OrderViewController: UIViewController {

    var event: Event?
    var organization: Organization?
    var restaurant: Restaurant?
    var total = 0
    
    // Close button
    let close: UIButton = {
        let close = UIButton()
        close.translatesAutoresizingMaskIntoConstraints = false
        close.addTarget(self, action: #selector(closePressed(sender:)), for: .touchUpInside)
        let image = UIImage(named: "close")?.withRenderingMode(.alwaysTemplate)
        close.setBackgroundImage(image, for: .normal)
        close.tintColor = .black
        return close
    }()
    
    // Price
    let priceLabel: UITextField = {
        let priceLabel = UITextField()
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.font = UIFont(name: "Avenir-Heavy", size: 48)
        priceLabel.addTarget(self, action: #selector(myTextFieldDidChange(_:)), for: .editingChanged)
        priceLabel.textColor = .black
        priceLabel.placeholder = "$0.00"
        priceLabel.textAlignment = .center
        return priceLabel
    }()
    
    // Checkout
    let checkout: MDCRaisedButton = {
        let checkout = MDCRaisedButton()
        checkout.translatesAutoresizingMaskIntoConstraints = false
        checkout.setTitle("Finish & Pay", for: .normal)
        checkout.addTarget(self, action: #selector(checkoutPressed(sender:)), for: .touchUpInside)
        checkout.setElevation(ShadowElevation(rawValue: 12), for: .normal)
        checkout.setTitleColor(.white, for: .normal)
        checkout.backgroundColor = .black
        return checkout
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutView()
        
        //restaurant assignment
        restaurant = Data.sharedInstance.restaurants.filter {
            $0.name == event?.title
        }.first
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getOrderTotal(price: String) -> Int {
        return Int(price.replacingOccurrences(of: ".", with: ""))!
    }
    
    @objc func checkoutPressed(sender: MDCRaisedButton) {
        if (priceLabel.text != "") {
            let merchantIdentifier = Constants.merchantID
            let paymentRequest = Stripe.paymentRequest(withMerchantIdentifier: merchantIdentifier, country: "US", currency: "USD")
            
            // Configure the line items on the payment request
            let cost = 100
            let tip = 100
            let price = NSDecimalNumber(value: cost + tip)
            paymentRequest.paymentSummaryItems = [
                PKPaymentSummaryItem(label: "Order Total", amount: price),
            ]
            
            if Stripe.canSubmitPaymentRequest(paymentRequest) {
                // Setup payment authorization view controller
                let paymentAuthorizationViewController = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest)
                paymentAuthorizationViewController?.delegate = self
                
                // Present payment authorization view controller
                present(paymentAuthorizationViewController!, animated: true)
            }
            else {
                // There is a problem with your Apple Pay configuration
                print("welp that did not work!")
            }
        }
    }
    
    @objc func myTextFieldDidChange(_: UITextField) {
        
        if let amountString = priceLabel.text?.currencyInputFormatting() {
            priceLabel.text = amountString
            if (priceLabel.text != "") {
                self.total = Int((priceLabel.text?.replacingOccurrences(of: ".", with: "").replacingOccurrences(of: "$", with: "").replacingOccurrences(of: ",", with: ""))!)!
            }
        }
    }
    
    @objc func closePressed(sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // This function gets reused throughout the app in different forms.
    // On each screen we build out elements and lay them out programatically based
    // on the positioning of one another. This makes our UI easily adaptable!
    func layoutView() {
        
        var marginGuide = view.layoutMarginsGuide
        if #available(iOS 11.0, *) {
            marginGuide = view.safeAreaLayoutGuide
        }
        
        var constraints = [NSLayoutConstraint]()
        
        view.addSubview(close)
        view.addSubview(priceLabel)
        view.addSubview(checkout)
        
        
        constraints.append(NSLayoutConstraint(item: close,
                                              attribute: .top,
                                              relatedBy: .equal,
                                              toItem: marginGuide,
                                              attribute: .top,
                                              multiplier: 1,
                                              constant: 20))
        constraints.append(NSLayoutConstraint(item: close,
                                              attribute: .leading,
                                              relatedBy: .equal,
                                              toItem: view,
                                              attribute: .leading,
                                              multiplier: 1,
                                              constant: 20))
        constraints.append(NSLayoutConstraint(item: close,
                                              attribute: .height,
                                              relatedBy: .equal,
                                              toItem: view,
                                              attribute: .height,
                                              multiplier: 0,
                                              constant: 40))
        constraints.append(NSLayoutConstraint(item: close,
                                              attribute: .width,
                                              relatedBy: .equal,
                                              toItem: view,
                                              attribute: .width,
                                              multiplier: 0,
                                              constant: 40))
        
        
        
        constraints.append(NSLayoutConstraint(item: priceLabel,
                                              attribute: .top,
                                              relatedBy: .equal,
                                              toItem: marginGuide,
                                              attribute: .top,
                                              multiplier: 1,
                                              constant: 150))
        constraints.append(NSLayoutConstraint(item: priceLabel,
                                              attribute: .leading,
                                              relatedBy: .equal,
                                              toItem: view,
                                              attribute: .leading,
                                              multiplier: 1,
                                              constant: 30))
        constraints.append(NSLayoutConstraint(item: priceLabel,
                                              attribute: .trailing,
                                              relatedBy: .equal,
                                              toItem: marginGuide,
                                              attribute: .trailing,
                                              multiplier: 1,
                                              constant: -30))
        
        constraints.append(NSLayoutConstraint(item: checkout,
                                              attribute: .bottom,
                                              relatedBy: .equal,
                                              toItem: marginGuide,
                                              attribute: .bottom,
                                              multiplier: 1,
                                              constant: -50))
        constraints.append(NSLayoutConstraint(item: checkout,
                                              attribute: .leading,
                                              relatedBy: .equal,
                                              toItem: marginGuide,
                                              attribute: .leading,
                                              multiplier: 1,
                                              constant: 30))
        constraints.append(NSLayoutConstraint(item: checkout,
                                              attribute: .trailing,
                                              relatedBy: .equal,
                                              toItem: marginGuide,
                                              attribute: .trailing,
                                              multiplier: 1,
                                              constant: -30))
        
        
        
        NSLayoutConstraint.activate(constraints)
    }
}
