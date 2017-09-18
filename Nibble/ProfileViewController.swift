//
//  ProfileViewController.swift
//  Nibble
//
//  Created by Sawyer Billings on 8/17/17.
//  Copyright © 2017 Sawyer Billings. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var user: String!
    @IBOutlet weak var close: UIButton!
    @IBOutlet weak var logout: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tableView = UITableView(frame: CGRect(x: self.view.center.x - ((self.view.bounds.width - 50) / 2), y: 150, width: self.view.bounds.width - 50, height: self.view.bounds.height - 100))
        tableView.separatorColor = UIColor.clear
        tableView.register(OrderViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.contentInset = UIEdgeInsetsMake(50, 0, -100, 0)
        tableView.backgroundColor = UIColor.flatBlack()
        self.view.addSubview(tableView)
        
        self.view.backgroundColor = UIColor.flatBlack()
        
        close.setImage(UIImage(named: "close"), for: .normal)
        close.addTarget(self, action: #selector(closePressed(_:)), for: UIControlEvents.touchUpInside)
        logout.tintColor = UIColor.flatRed()
        logout.addTarget(self, action: #selector(logoutPressed(_:)), for: .touchUpInside)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func closePressed(_ sender:UIButton!){
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! OrderViewCell
        
        let spots = Database.database().reference().child("orders")
        
        spots.observe(DataEventType.value, with: { (snapshot) in
            if (snapshot.childrenCount > 0) {
                var title = ""
                var price = "0"
                var deliver = ""
                var restaurant = ""
                var city = ""
                var order : [String] = []
                var status = ""
                for entries in snapshot.children.allObjects as! [DataSnapshot] {
                    let spot = entries.value as? [String: AnyObject]
                    if (spot?["email"] as! String == self.user) {
                        title = spot?["address1"] as! String
                        price = spot?["total"] as! String
                        deliver = spot?["deliver"] as! String
                        restaurant = spot?["restaurant"] as! String
                        order = spot?["selections"] as! [String]
                        status = spot?["status"] as! String
                    }
                    let orderDetails = order.joined(separator: "\n")
                    cell.orderDetails?.text = orderDetails
                    //cell.address?.text = title
                    cell.price?.text = price
                    cell.restaurant?.text = restaurant
                    if (status == "placed") {
                        cell.status.image = UIImage(named: "pending")
                    } else {
                        cell.status.image = UIImage(named: "fulfilled")
                    }
                    cell.layer.cornerRadius = 10
                    cell.layer.borderColor = UIColor.white.cgColor
                    cell.backgroundColor = UIColor.flatBlack()
                    cell.layer.borderWidth = 2
                }
            }
        })

        return cell
        
    }
    
    func logoutPressed(_ sender: AnyObject) {
        do {
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: "signoutSegue", sender: nil)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 150
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
