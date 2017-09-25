//
//  OrganizationsViewController.swift
//  Nibble
//
//  Created by Sawyer Billings on 9/25/17.
//  Copyright © 2017 Sawyer Billings. All rights reserved.
//

import UIKit
import MXParallaxHeader
import FirebaseAuth
import Firebase

class OrganizationsViewController: UITableViewController, MXParallaxHeaderDelegate {

    @IBOutlet var headerView: UIView!
    
    @IBOutlet weak var profile: UIButton!
    
    var ref: DatabaseReference!
    
    private var restaurants: [String] = []
    private var images: [String] = []
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
        
        let spots = Database.database().reference().child("organizations")
        
        spots.observe(DataEventType.value, with: { (snapshot) in
            if (snapshot.childrenCount > 0) {
                for entries in snapshot.children.allObjects as! [DataSnapshot] {
                    let spot = entries.value as? [String: AnyObject]
                    self.restaurants.append(spot?["name"] as! String)
                    self.images.append(spot?["icon"] as! String)
                }
                cell.myLabel1.text = "\(self.restaurants[indexPath.row])"
                cell.profile.downloadedFrom(link: self.images[indexPath.row])
            }
        })
        
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! RestaurantCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
    }
    
    func profilePressed(_ sender:UIButton!){
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
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

extension UIImageView {
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { () -> Void in
                self.image = image
            }
            }.resume()
    }
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
}
