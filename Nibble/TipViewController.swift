//
//  TipViewController.swift
//  Nibble
//
//  Created by Sawyer Billings on 11/15/17.
//  Copyright © 2017 Sawyer Billings. All rights reserved.
//

import UIKit
import Firebase

class TipViewController: UIViewController {
    var currOrder: Order?
    let settingsVC =  SettingsViewController()
    var tipCount = 0
    var existingCustomer: String?

    @IBOutlet weak var close: UIButton!
    @IBOutlet weak var checkout: UIButton!
    @IBOutlet weak var tip: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        checkout.addTarget(self, action: #selector(checkoutPressed(_:)), for: .touchUpInside)
        tip.addTarget(self, action: #selector(myTextFieldDidChange(_:)), for: .editingChanged)
        close.addTarget(self, action: #selector(closePressed(_:)), for: .touchUpInside)
        
        navigationController?.navigationBar.isHidden = true

        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getOrderTotal(price: String) -> Int {
        return Int(price.replacingOccurrences(of: ".", with: ""))!
    }
    
    func checkoutPressed(_: AnyObject) {
        if (tip.text != "") {
            //self.currOrder?.total += tipCount
//            let checkoutVC = CheckoutViewController(price: self.currOrder?.total!, tip: self.tipCount, settings: self.settingsVC.settings, restaurant: self.currOrder?.restaurant!, organization: self.currOrder?.organization!)
//            self.present(checkoutVC, animated: true, completion: nil)
            self.performSegue(withIdentifier: "checkoutSegue", sender: self)
        }
    }
    
    
    func myTextFieldDidChange(_: UITextField) {
        if let amountString = tip.text?.currencyInputFormatting() {
            tip.text = amountString
            if (tip.text != "") {
                self.tipCount = Int((tip.text?.replacingOccurrences(of: ".", with: "").replacingOccurrences(of: "$", with: "").replacingOccurrences(of: ",", with: ""))!)!
            }
        }
    }
    
    func closePressed(_: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "checkoutSegue" {
            if let toViewController = segue.destination as? StripeCheckoutViewController {
                currOrder?.tip = self.tipCount
                toViewController.order = currOrder
                toViewController.navigationController?.navigationBar.isHidden = false
            }
        }
    }
}
