//
//  RestaurantViewController.swift
//  Nibble
//
//  Created by Sawyer Billings on 8/15/17.
//  Copyright © 2017 Sawyer Billings. All rights reserved.
//

import UIKit
import MXParallaxHeader
import FirebaseAuth
import Firebase
import AVFoundation
import AudioToolbox

class RestaurantOrderTableViewController: UITableViewController, MXParallaxHeaderDelegate {
    
    @IBOutlet var headerView: UIView!
    
    @IBOutlet weak var logout: UIButton!
    
    
    var ref: DatabaseReference!
    
    private var restaurants: [String] = []
    var selected: String?
    var indexPath: IndexPath!
    var user: User!
    var restaurant = "Portland Pie Company"
    var type : [String] = []
    var city : [String] = []
    var phone : [String] = []
    var address1 : [String] = []
    var address2: [String] = []
    var prices: [String] = []
    var counter: [String] = []
    var status: [String] = []
    var selections: [[String]] = [[]]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.counter = []
        self.type = []
        self.address2 = []
        self.address1 = []
        self.city = []
        self.phone = []
        self.prices = []
        
        ref = Database.database().reference()
        
        logout.tintColor = UIColor.flatRed()
        logout.addTarget(self, action: #selector(logoutPressed(_:)), for: .touchUpInside)
        
        let items = Database.database().reference().child("orders")
        items.observe(.value, with: { snapshot in
            for item in snapshot.children.allObjects as! [DataSnapshot] {
                let menuObject = item.value as? [String: AnyObject]
                if ((menuObject?["restaurant"] as! String).contains(self.restaurant)) {
                    self.counter.append("found")
                }
            }
            self.tableView.reloadData()
        })
        
        // Parallax Header
        tableView.parallaxHeader.view = headerView // You can set the parallax header view from the floating view
        tableView.parallaxHeader.height = 260
        tableView.parallaxHeader.mode = MXParallaxHeaderMode.fill
        tableView.parallaxHeader.minimumHeight = 20
        
        tableView.parallaxHeader.delegate = self
        tableView.register(RestaurantOrderCell.self, forCellReuseIdentifier: "Cell")
        tableView.separatorStyle = .singleLine
        
        Auth.auth().addStateDidChangeListener { auth, user in
            guard let user = user else { return }
        }
        
        startRefreshTimer()
        
    }
    
    func startRefreshTimer() {
        _ = Timer.scheduledTimer(timeInterval: 15.0, target: self, selector: #selector(refresh), userInfo: nil, repeats: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return counter.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! RestaurantOrderCell
        
        let items = Database.database().reference().child("orders")
        
        items.observe(DataEventType.value, with: { (snapshot) in
            if (snapshot.childrenCount > 0) {
                for item in snapshot.children.allObjects as! [DataSnapshot] {
                    let orderObject = item.value as? [String: AnyObject]
                    if ((orderObject?["restaurant"] as! String).contains(self.restaurant)) {
                        self.type.append(orderObject?["deliver"] as! String )
                        self.address1.append(orderObject?["address1"] as! String)
                        self.address2.append(orderObject?["address2"] as! String)
                        self.city.append(orderObject?["city"] as! String)
                        self.phone.append(orderObject?["phone"] as! String)
                        self.prices.append(orderObject?["total"] as! String)
                        self.selections.append(orderObject?["selections"] as! [String])
                        self.status.append(orderObject?["status"] as! String)
                    }
                }
                self.type.reverse()
                self.address1.reverse()
                self.address2.reverse()
                self.city.reverse()
                self.phone.reverse()
                self.prices.reverse()
                self.selections.reverse()
                self.status.reverse()
                
                cell.type.text = self.type[indexPath.row].uppercased()
                cell.address1.text = self.address1[indexPath.row]
                cell.address2.text = self.address2[indexPath.row]
                cell.city.text = self.city[indexPath.row]
                cell.price.text = self.prices[indexPath.row]
                cell.phone.text = self.phone[indexPath.row]
                let string = self.selections[indexPath.row].joined(separator: "\n")
                cell.orderDetails.text = string
                if (self.status[indexPath.row] != "placed") {
                    cell.orderStatus.image = UIImage(named: "fulfilled")
                } else {
                    cell.orderStatus.image = UIImage(named: "placed")
                }
            }
        })
        
        return cell
    }
    
    func refresh()
    {
        self.counter.removeAll()
        self.type.removeAll()
        self.address2.removeAll()
        self.address1.removeAll()
        self.city.removeAll()
        self.phone.removeAll()
        self.prices.removeAll()
        
        let items = Database.database().reference().child("orders")
        items.observe(.value, with: { snapshot in
            for item in snapshot.children.allObjects as! [DataSnapshot] {
                let menuObject = item.value as? [String: AnyObject]
                if ((menuObject?["restaurant"] as! String).contains(self.restaurant)) {
                    self.counter.append("found")
                }
                self.tableView.reloadData()
            }
        })
        
        
        let items2 = Database.database().reference().child("orders")
        
        items2.observe(DataEventType.value, with: { (snapshot) in
            if (snapshot.childrenCount > 0) {
                for item in snapshot.children.allObjects as! [DataSnapshot] {
                    let orderObject = item.value as? [String: AnyObject]
                    if ((orderObject?["restaurant"] as! String).contains(self.restaurant)) {
                        self.type.append(orderObject?["deliver"] as! String )
                        self.address1.append(orderObject?["address1"] as! String)
                        self.address2.append(orderObject?["address2"] as! String)
                        self.city.append(orderObject?["city"] as! String)
                        self.phone.append(orderObject?["phone"] as! String)
                        self.prices.append(orderObject?["total"] as! String)
                        self.status.append(orderObject?["status"] as! String)
                    }
                }
            }
        })
    
        self.tableView.reloadData()
    }
    
    /*
    func playSound() {
        let url = Bundle.main.url(forResource: "ClickSound", withExtension: "mp3")!
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            guard let player = player else { return }
            
            player.prepareToPlay()
            player.play()
        } catch let error as NSError {
            print(error.description)
        }
    }
      */
    
    func logoutPressed(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "dashLogout", sender: nil)
    }

    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! RestaurantOrderCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        let alert = UIAlertController(title: "Order Complete",
                                      message: "Mark order as completed?",
                                      preferredStyle: .alert)
        
        let updateAction = UIAlertAction(title: "Complete", style: .default) { action in
            print("fulfilled order!")
            //get the current cell being tapped and change the status of the order. 
            let items2 = Database.database().reference().child("orders")
            
            items2.observe(DataEventType.value, with: { (snapshot) in
                if (snapshot.childrenCount > 0) {
                    for item in snapshot.children.allObjects as! [DataSnapshot] {
                        let orderObject = item.value as? [String: AnyObject]
                        if ((orderObject?["phone"] as! String).contains(cell.phone.text!)) {
                        self.ref.child("orders").child(item.key).updateChildValues(["status": "fulfilled"])
                            self.refresh()
                        }
                    }
                }
            })
            self.tableView.reloadData()
            self.tableView.reloadData()
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        
        alert.addAction(cancelAction)
        alert.addAction(updateAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 200
    }
}
