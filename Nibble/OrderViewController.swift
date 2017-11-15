//
//  OrderViewController.swift
//  Nibble
//
//  Created by Sawyer Billings on 11/14/17.
//  Copyright © 2017 Sawyer Billings. All rights reserved.
//

import UIKit

class OrderViewController: UIViewController {
    
    var organization: Organization?
    var restaurant: Restaurant?

    override func viewDidLoad() {
        super.viewDidLoad()
        print(organization?.name)
        print(restaurant?.name)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
