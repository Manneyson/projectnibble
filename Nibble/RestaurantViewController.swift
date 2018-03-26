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
import Kingfisher
import SCLAlertView

class RestaurantViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var logout: UIButton!
    var ref: DatabaseReference!
    private var restaurants: [Restaurant] = []
    var organizations: [Organization] = []
    let settingsVC = SettingsViewController()
    var organizationSelected: Organization?
    var restaurantSelected: Restaurant?

    var selected: String?
    var indexPath: IndexPath!
    var user: User!
    var start : [Int] = []
    var end : [Int] = []


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.flatMint()
        
        logout.tintColor = UIColor.white
        logout.addTarget(self, action: #selector(self.logoutPressed(_:)), for: UIControlEvents.touchUpInside)
        
        tableView.register(RestaurantCell.self, forCellReuseIdentifier: "Cell")
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor.flatMint()
        
        Auth.auth().addStateDidChangeListener { auth, user in
            guard let user = user else { return }
        }
        
        self.loadRestaurants()
        self.loadOrganizations()
    }
    
    func loadRestaurants() {
        let hud = HUD.showLoading()
        let spots = Database.database().reference().child("restaurants")
        spots.observe(DataEventType.value, with: { (snapshot) in
            if (snapshot.childrenCount > 0) {
                for entries in snapshot.children.allObjects as! [DataSnapshot] {
                    let spot = entries.value as? [String: AnyObject]
                    self.restaurants.append(Restaurant(name: spot?["name"] as! String, pledge: spot?["pledge"] as! Double, stripe: spot?["stripe"] as! String, open: spot?["open"] as! Int, close: spot?["close"] as! Int, icon: spot?["icon"] as! String, info: spot?["info"] as! String, header: spot?["header"] as! String))
                }
            }
            self.tableView.reloadData()
        })
        hud.dismiss()
    }
    
    func loadOrganizations() {
        let hud = HUD.showLoading()
        let organizations = Database.database().reference().child("organizations")
        organizations.observe(DataEventType.value, with: { (snapshot) in
            if (snapshot.childrenCount > 0) {
                for entries in snapshot.children.allObjects as! [DataSnapshot] {
                    let spot = entries.value as? [String: AnyObject]
                    self.organizations.append(Organization(name: spot?["name"] as! String, info: spot?["info"] as! String, icon: spot?["icon"] as! String, stripe: spot?["stripe"] as! String, url: spot?["url"] as! String))
                }
            }
            self.tableView.reloadData()
            hud.dismiss()
        })
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
        return self.restaurants.count
    }
    
    
    /// Query all of the existing restaurants from the server and display them with their
    /// corresponding image and menu link
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! RestaurantCell
        cell.backgroundView?.backgroundColor = UIColor.flatMint()
        cell.myLabel1.text = "\(self.restaurants[indexPath.section].name)"
        let url = URL(string: self.restaurants[indexPath.section].icon)
        cell.profile.kf.setImage(with: url)
        cell.menu.addTarget(self, action: #selector(self.menuPressed(_:)), for: UIControlEvents.touchUpInside)
        return cell
    }
    
    // MARK: - Table view delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! RestaurantCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
    }
    
    func menuPressed(_ sender:UIButton!) {
        let cell = sender.superview?.superview as! UITableViewCell
        indexPath = self.tableView.indexPath(for: cell)
        
        let alertView = SCLAlertView()
        for org in self.organizations {
            alertView.addButton("\(org.name)")  {
                self.organizationSelected = org
                self.restaurantSelected = self.restaurants[self.indexPath.section]
                self.performSegue(withIdentifier: "orderSegue", sender: self)
            }
        }
        alertView.showSuccess(
            "Organization Selection",
            subTitle: "Please select a non profit",
            colorStyle: 0x00000)
    }
    
    func profilePressed(_ sender: UIButton!){
        
    }
    
    func logoutPressed(_ sender: AnyObject) {
        
        let alert = UIAlertController(title: "Settings", message: "Select an option below.", preferredStyle: .actionSheet)
        
        let logout = UIAlertAction(title: "Logout", style: .destructive) { action in
            do {
                try Auth.auth().signOut()
                self.performSegue(withIdentifier: "signoutSegue", sender: nil)
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)

        alert.addAction(logout)
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
//        if segue.identifier == "menuSegue" {
//            if let toViewController = segue.destination as? ViewController {
//                toViewController.restaurant = self.restaurants[indexPath.section]
//            }
//        }
        
        if segue.identifier == "profileSegue" {
            if let toViewController = segue.destination as? ProfileViewController {
                toViewController.user = Auth.auth().currentUser?.email
                toViewController.restaurants = self.restaurants
                toViewController.organizations = self.organizations
            }
        }
        
        if segue.identifier == "orderSegue" {
            print(self.restaurantSelected)
            print(self.organizationSelected)
            if let toViewController = segue.destination as? OrderViewController {
                toViewController.restaurant = self.restaurantSelected
                toViewController.organization = self.organizationSelected
                toViewController.total = 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 200
    }
}
