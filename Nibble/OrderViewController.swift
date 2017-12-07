//
//  OrderViewController.swift
//  Nibble
//
//  Created by Sawyer Billings on 11/14/17.
//  Copyright © 2017 Sawyer Billings. All rights reserved.
//

import UIKit
import RZTransitions

class OrderViewController: UIViewController {
    
    var organization: Organization?
    var restaurant: Restaurant?
    let settingsVC = SettingsViewController()
    var total = 0


    @IBOutlet weak var close: UIButton!
    @IBOutlet weak var checkout: UIButton!
    @IBOutlet weak var price: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkout.addTarget(self, action: #selector(checkoutPressed(_:)), for: .touchUpInside)
        price.addTarget(self, action: #selector(myTextFieldDidChange(_:)), for: .editingChanged)
        close.addTarget(self, action: #selector(closePressed(_:)), for: .touchUpInside)

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
        if (price.text != "") {
            self.performSegue(withIdentifier: "tipSegue", sender: self)
        }
    }
    
    func myTextFieldDidChange(_: UITextField) {
        
        if let amountString = price.text?.currencyInputFormatting() {
            price.text = amountString
            if (price.text != "") {
                self.total = Int((price.text?.replacingOccurrences(of: ".", with: "").replacingOccurrences(of: "$", with: ""))!)!
            }
        }
    }
    
    func closePressed(_: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "tipSegue" {
            if let toViewController = segue.destination as? TipViewController {
                toViewController.restaurant = self.restaurant
                toViewController.organization = self.organization
                toViewController.total = self.total
            }
        }
    }
}
    
extension String {
    
    // formatting text for currency textField
    func currencyInputFormatting() -> String {
        
        var number: NSNumber!
        let formatter = NumberFormatter()
        formatter.numberStyle = .currencyAccounting
        formatter.currencySymbol = "$"
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        
        var amountWithPrefix = self
        
        // remove from String: "$", ".", ","
        let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
        amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count), withTemplate: "")
        
        let double = (amountWithPrefix as NSString).doubleValue
        number = NSNumber(value: (double / 100))
        
        // if first number is 0 or all numbers were deleted
        guard number != 0 as NSNumber else {
            return ""
        }
        
        return formatter.string(from: number)!
    }
}
