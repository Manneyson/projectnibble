//
//  TipViewController.swift
//  Nibble
//
//  Created by Sawyer Billings on 11/15/17.
//  Copyright © 2017 Sawyer Billings. All rights reserved.
//

import UIKit

class TipViewController: UIViewController {
    var restaurant: Restaurant?
    var organization: Organization?
    let settingsVC =  SettingsViewController()
    var total: Int?
    var tipCount = 0

    @IBOutlet weak var close: UIButton!
    @IBOutlet weak var checkout: UIButton!
    @IBOutlet weak var tip: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        checkout.addTarget(self, action: #selector(checkoutPressed(_:)), for: .touchUpInside)
        tip.addTarget(self, action: #selector(myTextFieldDidChange(_:)), for: .editingChanged)
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
        if (tip.text != "") {
            let checkoutVC = CheckoutViewController(price: self.total! + self.tipCount, settings: settingsVC.settings, restaurant: self.restaurant!, organization: self.organization!)
            self.present(checkoutVC, animated: true, completion: nil)
        }
    }
    
    func myTextFieldDidChange(_: UITextField) {
        
        if let amountString = tip.text?.currencyInputFormatting() {
            tip.text = amountString
            self.tipCount = Int((tip.text?.replacingOccurrences(of: ".", with: "").replacingOccurrences(of: "$", with: ""))!)!
        }
    }
    
    func closePressed(_: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
}
