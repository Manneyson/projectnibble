//
//  SocialFeedViewController.swift
//  Nibble
//
//  Created by Sawyer Billings on 3/26/18.
//  Copyright © 2018 Sawyer Billings. All rights reserved.
//

import UIKit
import UIKit
import MXParallaxHeader
import FirebaseAuth
import Firebase
import Kingfisher

class SocialFeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    @IBOutlet weak var tableView: UITableView!
    
    var ref: DatabaseReference!
    
    private var orders: [Order] = []
    private var restaurants: [Restaurant] = []
//    private var organizations: [Organization] = []

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        tableView.register(SocialCell.self, forCellReuseIdentifier: "SocialCell")
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor.flatMint()
        tableView.estimatedRowHeight = 110
        
        self.loadOrders()
    }
    
    func loadOrders() {
        let hud = HUD.showLoading()
        let organizations = Database.database().reference().child("orders")
        organizations.observe(DataEventType.value, with: { (snapshot) in
            if (snapshot.childrenCount > 0) {
                for entries in snapshot.children.allObjects as! [DataSnapshot] {
                    let spot = entries.value as? [String: AnyObject]
                    self.orders.append(Order(email: spot?["email"] as! String, restaurant: SharedData.sharedInstance.restaurants.first(where: {$0.name == spot?["restaurant"] as? String})!, organization: SharedData.sharedInstance.organizations.first(where: {$0.name == spot?["organization"] as! String})!, total: 0, tip: 0, donation: 0))
                }
            }
            self.tableView.reloadData()
        })
        hud.dismiss()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 30))
        headerView.backgroundColor = UIColor.flatMint()
        return headerView
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SocialCell") as! SocialCell
        
        cell.backgroundColor = UIColor.flatMint()
        
        let name = Auth.auth().currentUser?.email?.components(separatedBy: "@").first ?? "Anonymous user"
        cell.myLabel1.text = self.orders.reversed()[indexPath.section].restaurant.name
        let url = URL(string: self.orders.reversed()[indexPath.section].organization.icon)
        cell.profile.kf.setImage(with: url)
        cell.detailLabel.text = "@\(name) made a difference for \(self.orders[indexPath.section].organization.name)"
        
        return cell
    }
    
    
    // MARK: - Table view delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! SocialCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
    }
    
}

