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
import SACountingLabel
import Kingfisher

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var recent3: UIImageView!
    @IBOutlet weak var recent2: UIImageView!
    @IBOutlet weak var recent1: UIImageView!
    @IBOutlet weak var label: SACountingLabel!
    @IBOutlet weak var profileCardImage: UIImageView!
    @IBOutlet weak var profileCard: UIView!
    var user: String!
    @IBOutlet weak var close: UIButton!
    private var recentOrders: [Order] = []
    var restaurants: [Restaurant]?
    var organizations: [Organization]?
    var totalDonation = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.flatMint()
        
        getMostRecent()
        
        close.setImage(UIImage(named: "close"), for: .normal)
        close.addTarget(self, action: #selector(closePressed(_:)), for: UIControlEvents.touchUpInside)
    }
    
    func assignLabels() {
        label.font = UIFont(name: "Avenir-Heavy", size: 25)
        label.countFrom(fromValue: 0, to: Float(totalDonation) / 100, withDuration: 1.0, andAnimationType: .EaseIn, andCountingType: .Custom)
        label.textAlignment = .center
        label.format = "$%.2f%"
    }
    
    func getMostRecent() {
        let hud = HUD.showLoading()
        let organizations = Database.database().reference().child("orders")
        organizations.observe(DataEventType.value, with: { (snapshot) in
            if (snapshot.childrenCount > 0) {
                for entries in snapshot.children.allObjects as! [DataSnapshot] {
                    let spot = entries.value as? [String: AnyObject]
                    if (Auth.auth().currentUser?.email == spot?["email"] as! String) {
                        self.recentOrders.append(Order(email: spot?["email"] as! String, restaurant: self.restaurants!.first(where: {$0.name == spot?["restaurant"] as? String})!, organization: self.organizations!.first(where: {$0.name == spot?["organization"] as! String})!, total: spot?["subtotal"] as! String, tip: "", donation: spot?["donation"] as! String))
                        var donation = spot?["donation"] as! Int
                        self.totalDonation += donation
                    }
                }
            }
            self.assignRecentDonationImages()
            self.assignLabels()
        })
        hud.dismiss()
    }
    
    func assignRecentDonationImages() {
        if self.recentOrders.count > 2 {
            let url1 = URL(string: self.recentOrders.reversed()[0].organization.icon)
            recent1.kf.setImage(with: url1)
            
            let url2 = URL(string: self.recentOrders.reversed()[1].organization.icon)
            recent2.kf.setImage(with: url2)
            
            let url3 = URL(string: self.recentOrders.reversed()[2].organization.icon)
            recent3.kf.setImage(with: url3)
        } else if self.recentOrders.count == 2 {
            let url1 = URL(string: self.recentOrders.reversed()[0].organization.icon)
            recent1.kf.setImage(with: url1)
            
            let url2 = URL(string: self.recentOrders.reversed()[1].organization.icon)
            recent2.kf.setImage(with: url2)
        } else if self.recentOrders.count == 1 {
            let url1 = URL(string: self.recentOrders[0].organization.icon)
            recent1.kf.setImage(with: url1)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 30))
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func closePressed(_ sender:UIButton!){
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! OrderViewCell
        
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

}
