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

class RestaurantViewController: UITableViewController, MXParallaxHeaderDelegate {
    
    @IBOutlet var headerView: UIView!
    
    @IBOutlet weak var profile: UIButton!
    
    var ref: DatabaseReference!

    
    //var restaurants = ["Big E's", "Little Tokyo", "Portland Pie Company", "Asian Garden"]
    private var restaurants: [String] = []
    private var destinations: [String] = []

    var selected: String?
    var indexPath: IndexPath!
    var user: User!
    var start : [Int] = []
    var end : [Int] = []


    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
        profile.addTarget(self, action: #selector(profilePressed(_:)), for: .touchUpInside)
        profile.tintColor = UIColor.white
        
        
        // Parallax Header
        tableView.parallaxHeader.view = headerView // You can set the parallax header view from the floating view
        tableView.parallaxHeader.height = 260
        tableView.parallaxHeader.mode = MXParallaxHeaderMode.fill
        tableView.parallaxHeader.minimumHeight = 20
        
        tableView.parallaxHeader.delegate = self
        tableView.register(RestaurantCell.self, forCellReuseIdentifier: "Cell")
        tableView.separatorStyle = .none
        
        Auth.auth().addStateDidChangeListener { auth, user in
            guard let user = user else { return }
            self.user = User(uid: user.uid, email: user.email!)
        }
        
        /// Query in the closing hour of all the restaurants to be displayed
        let items = Database.database().reference().child("hours")
        items.observe(DataEventType.value, with: { (snapshot) in
            if (snapshot.childrenCount > 0) {
                for entries in snapshot.children.allObjects as! [DataSnapshot] {
                    let hours = entries.value as? String
                    let startHour = hours?.substring(to: (hours?.characters.index(of: "-"))!)
                    var endHour = hours?.substring(from: (hours?.characters.index(of: "-"))!)
                    endHour?.characters.removeFirst()
                    self.start.append(((startHour as NSString?)?.integerValue)!)
                    self.end.append(((endHour as NSString?)?.integerValue)!)
                }
            }
            self.tableView.reloadData()
        })
        
        let destinations = Database.database().reference().child("stripe")
        destinations.observe(DataEventType.value, with: { (snapshot) in
            if (snapshot.childrenCount > 0) {
                for entries in snapshot.children.allObjects as! [DataSnapshot] {
                    let dest = entries.value as? String
                    self.destinations.append(dest!)
                }
            }
        })
    }
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return start.count
    }
    
    
    /// Query all of the existing restaurants from the server and display them with their
    /// corresponding image and menu link
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! RestaurantCell

        let spots = Database.database().reference().child("restaurants")

        spots.observe(DataEventType.value, with: { (snapshot) in
            if (snapshot.childrenCount > 0) {
                for entries in snapshot.children.allObjects as! [DataSnapshot] {
                    let spot = entries.value as? String
                    self.restaurants.append(spot!)
                }
                cell.myLabel1.text = "\(self.restaurants[indexPath.row])"
                cell.profile.image = UIImage(named: self.restaurants[indexPath.row]) ?? UIImage(named: "placeholder")
                cell.menu.addTarget(self, action: #selector(self.menuPressed(_:)), for: UIControlEvents.touchUpInside)
            }
        })
        
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! RestaurantCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
    }
    
    func menuPressed(_ sender:UIButton!){
        let cell = sender.superview?.superview as! UITableViewCell
        indexPath = self.tableView.indexPath(for: cell)

        let curr = self.tableView.indexPath(for: cell)
        
        
        let calendar = Calendar.current
        let date = Date()

        let hour = calendar.component(.hour, from: date)
        print("current hour : \(hour)")
        
        
        /// Need to check to see if the menu being requested is tied to an open
        /// restaurant. We query for open and closing on times when the view is loaded. 
        
        ///NOTE: The logic accounts for times that go past midnight!
        
        if ((start[(curr?.row)!]) > end[(curr?.row)!]) {
            if ((end[(curr?.row)!]...start[(curr?.row)!]-1).contains(hour) == false) {
                self.performSegue(withIdentifier: "menuSegue", sender: sender)
            } else {
                let alertController = UIAlertController(title: "Restaurant Closed", message: "We're sorry but the restaurant you're trying to view is currently closed!", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .cancel)
                alertController.addAction(action)
                self.present(alertController, animated: true, completion: nil)
            }
        } else {
            if ((start[(curr?.row)!]...end[(curr?.row)!]-1).contains(hour)) {
                self.performSegue(withIdentifier: "menuSegue", sender: sender)
            } else {
                let alertController = UIAlertController(title: "Restaurant Closed", message: "We're sorry but the restaurant you're trying to view is currently closed!", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .cancel)
                alertController.addAction(action)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    func profilePressed(_ sender:UIButton!){
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "menuSegue" {
            let cell = tableView(tableView, cellForRowAt: indexPath) as! RestaurantCell
            if let toViewController = segue.destination as? ViewController {
                toViewController.restaurant = self.restaurants[indexPath.row]
                toViewController.destination = self.destinations[indexPath.row]
            }
        }
        
        if segue.identifier == "profileSegue" {
            if let toViewController = segue.destination as? ProfileViewController {
                toViewController.user = user.email
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 150
    }
}
