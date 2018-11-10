//
//  HomeViewController.swift
//  nibble
//
//  Created by Sawyer Billings on 10/26/18.
//  Copyright © 2018 sbilling. All rights reserved.
//

import UIKit
import Firebase
import MaterialComponents.MaterialTabs
import CodableFirebase
import SDWebImage

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MDCTabBarControllerDelegate {
    
    let tabBar: MDCTabBar = {
        let tabBar = MDCTabBar()
        tabBar.translatesAutoresizingMaskIntoConstraints = false
        tabBar.items = [
            UITabBarItem(title: "Restaurants", image: UIImage(named: ""), tag: 0),
            UITabBarItem(title: "Organizations", image: UIImage(named: ""), tag: 1),
        ]
        return tabBar
    }()
    
    let profileButton: UIButton = {
        let profileButton = UIButton()
        profileButton.translatesAutoresizingMaskIntoConstraints = false
        profileButton.setImage(UIImage(named: "profile"), for: .normal)
        return profileButton
    }()
    
    let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "nibble"
        titleLabel.font = UIFont(name: "Avenir-Heavy", size: 24)
        titleLabel.textColor = .black
        titleLabel.backgroundColor = .white
        titleLabel.textAlignment = .center
        titleLabel.isUserInteractionEnabled = true
        return titleLabel
    }()
    
    let eventsTable: UITableView = {
        let eventsTable = UITableView()
        eventsTable.translatesAutoresizingMaskIntoConstraints = false
        return eventsTable
    }()
    
    let organizationsTable: UITableView = {
        let organizationsTable = UITableView()
        organizationsTable.translatesAutoresizingMaskIntoConstraints = false
        organizationsTable.allowsSelection = false
        return organizationsTable
    }()
    
    //instance variables
    var selectedEvent: Event?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // First we layout our views
        layoutViews()
        
        // Then we register our custom cell type with our tableview, load the data and refresh!
        eventsTable.register(EventCell.self, forCellReuseIdentifier: "event")
        eventsTable.delegate = self
        eventsTable.dataSource = self
        eventsTable.backgroundColor = .white
        eventsTable.estimatedRowHeight = 150
        eventsTable.rowHeight = UITableViewAutomaticDimension
        eventsTable.separatorStyle = .singleLine
        eventsTable.allowsSelection = true
        
        organizationsTable.register(OrganizationCell.self, forCellReuseIdentifier: "org")
        organizationsTable.delegate = self
        organizationsTable.dataSource = self
        organizationsTable.backgroundColor = .white
        organizationsTable.estimatedRowHeight = 200
        organizationsTable.rowHeight = UITableViewAutomaticDimension
        organizationsTable.separatorStyle = .none
        organizationsTable.allowsSelection = false
        organizationsTable.isHidden = true
        
        tabBar.delegate = self
        //searchButton.addTarget(self, action: #selector(searchPressed(sender:)), for: .touchUpInside)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        API.shared.loadEvents { (event) in
            self.eventsTable.reloadData()
        }
        
        API.shared.loadRestaurants { (restaurant) in
            print("succesfully loaded restaurants")
        }
        
        API.shared.loadOrganizations { (org) in
            self.organizationsTable.reloadData()
        }
    }
    
    @objc func profilePressed(sender: UIButton?) {
        let options = UIAlertController(title: "Profile", message: "", preferredStyle: .actionSheet)
        
        options.addAction(UIAlertAction(title: "Logout", style: .destructive, handler: { (alert) in
            do {
                try Auth.auth().signOut()
                self.dismiss(animated: true, completion: nil)
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
        }))
        
        options.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (alert) in
            options.dismiss(animated: true, completion: nil)
        }))
        
        self.present(options, animated: true)
    }
    
    @objc func searchPressed(sender: Any?) {
        //self.performSegue(withIdentifier: "searchSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "orderSegue") {
            if let toViewController = segue.destination as? OrderViewController {
                toViewController.event = self.selectedEvent
            }
        }
    }
    
    // This function determines how many tableview cells are present.
    // In our case, we wire it to the number of "offerings" coming back from Firebase.
    // Try adding an "offering" object to Firebase. The table automatically reloads!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case organizationsTable:
            return Data.sharedInstance.organizations.count
        case eventsTable:
            return Data.sharedInstance.events.count
        default:
            return Data.sharedInstance.organizations.count
        }
    }
    
//    // This function determines the height of a tableview cell. You may want to adjust it!
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 130
//    }
    
    // This function is called by the reload function. Each time reloadData() is called
    // this function will iterate through the number of tableview cells it knows are present.
    // We have connected the array of offerings to our tableview cell count so each reload
    // will execute the function below n times where n is the number of offerings in the offerings array.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == eventsTable {
            organizationsTable.isHidden = true
            let cell = tableView.dequeueReusableCell(withIdentifier: "event") as! EventCell
    
            cell.title.text = Data.sharedInstance.events[indexPath.row].title
            cell.date.text = Data.sharedInstance.events[indexPath.row].date
            cell.venue.text = Data.sharedInstance.restaurants.first { $0.id == Data.sharedInstance.events[indexPath.row].restaurant }?.name
            
            let url = URL(string: Data.sharedInstance.restaurants.first
                    { $0.id == Data.sharedInstance.events[indexPath.row].restaurant }?.icon ?? "nil")
            cell.icon.sd_setImage(with: url, placeholderImage: UIImage(named: ""))
    
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "org") as! OrganizationCell
    
            cell.name.text = Data.sharedInstance.organizations[indexPath.row].name
            cell.info.text = Data.sharedInstance.organizations[indexPath.row].info
            
            let url = URL(string: Data.sharedInstance.organizations[indexPath.row].icon)
            cell.icon.sd_setImage(with: url, placeholderImage: UIImage(named: ""))
    
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableView {
        case eventsTable:
            self.selectedEvent = Data.sharedInstance.events[indexPath.row]
            self.performSegue(withIdentifier: "orderSegue", sender: self)
        case organizationsTable:
            print("probably gonna fire off safari")
        default:
            self.selectedEvent = Data.sharedInstance.events[indexPath.row]
            self.performSegue(withIdentifier: "orderSegue", sender: self)
        }
    }
    
    func tabBar(_ tabBar: MDCTabBar, willSelect item: UITabBarItem) {
        switch item.tag {
        case 0:
            eventsTable.isHidden = false
            organizationsTable.isHidden = true
            eventsTable.reloadData()
        case 1:
            eventsTable.isHidden = true
            organizationsTable.isHidden = false
            organizationsTable.reloadData()
        default:
            eventsTable.isHidden = false
            organizationsTable.isHidden = true
        }
    }
    
    func layoutViews() {
        view.backgroundColor = .white
        
        var marginGuide = view.layoutMarginsGuide
        if #available(iOS 11.0, *) {
            marginGuide = view.safeAreaLayoutGuide
        }
        
        var constraints = [NSLayoutConstraint]()
        
        tabBar.frame = view.frame
        tabBar.backgroundColor = .white
        tabBar.itemAppearance = .titles
        tabBar.alignment = .justified
        tabBar.setTitleColor(UIColor.black, for: .normal)
        tabBar.setTitleColor(UIColor.black, for: .selected)
        tabBar.tintColor = Colors.primaryGreen
        tabBar.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
        tabBar.sizeToFit()
        
        profileButton.addTarget(self, action: #selector(profilePressed(sender:)), for: .touchUpInside)
        
        
        view.addSubview(titleLabel)
        view.addSubview(tabBar)
        view .addSubview(profileButton)
        view.addSubview(eventsTable)
        view.addSubview(organizationsTable)
        
        constraints.append(NSLayoutConstraint(item: titleLabel,
                                              attribute: .top,
                                              relatedBy: .equal,
                                              toItem: marginGuide,
                                              attribute: .top,
                                              multiplier: 1,
                                              constant: 20))
        constraints.append(NSLayoutConstraint(item: titleLabel,
                                              attribute: .leading,
                                              relatedBy: .equal,
                                              toItem: view,
                                              attribute: .leading,
                                              multiplier: 1,
                                              constant: 0))
        constraints.append(NSLayoutConstraint(item: titleLabel,
                                              attribute: .trailing,
                                              relatedBy: .equal,
                                              toItem: view,
                                              attribute: .trailing,
                                              multiplier: 1,
                                              constant: 0))
        
        constraints.append(NSLayoutConstraint(item: profileButton,
                                              attribute: .top,
                                              relatedBy: .equal,
                                              toItem: marginGuide,
                                              attribute: .top,
                                              multiplier: 1,
                                              constant: 20))
        constraints.append(NSLayoutConstraint(item: profileButton,
                                              attribute: .bottom,
                                              relatedBy: .equal,
                                              toItem: titleLabel,
                                              attribute: .bottom,
                                              multiplier: 1,
                                              constant: 0))
        
        constraints.append(NSLayoutConstraint(item: profileButton,
                                              attribute: .leading,
                                              relatedBy: .equal,
                                              toItem: marginGuide,
                                              attribute: .trailing,
                                              multiplier: 1,
                                              constant: -60))
        constraints.append(NSLayoutConstraint(item: profileButton,
                                              attribute: .trailing,
                                              relatedBy: .equal,
                                              toItem: marginGuide,
                                              attribute: .trailing,
                                              multiplier: 1,
                                              constant: -10))
        
        
        
        constraints.append(NSLayoutConstraint(item: tabBar,
                                              attribute: .top,
                                              relatedBy: .equal,
                                              toItem: titleLabel,
                                              attribute: .bottom,
                                              multiplier: 1,
                                              constant: 20))
        constraints.append(NSLayoutConstraint(item: tabBar,
                                              attribute: .leading,
                                              relatedBy: .equal,
                                              toItem: view,
                                              attribute: .leading,
                                              multiplier: 1,
                                              constant: 0))
        constraints.append(NSLayoutConstraint(item: tabBar,
                                              attribute: .trailing,
                                              relatedBy: .equal,
                                              toItem: view,
                                              attribute: .trailing,
                                              multiplier: 1,
                                              constant: 0))
        constraints.append(NSLayoutConstraint(item: eventsTable,
                                              attribute: .top,
                                              relatedBy: .equal,
                                              toItem: tabBar,
                                              attribute: .bottom,
                                              multiplier: 1,
                                              constant: 0))
        constraints.append(NSLayoutConstraint(item: eventsTable,
                                              attribute: .leading,
                                              relatedBy: .equal,
                                              toItem: view,
                                              attribute: .leading,
                                              multiplier: 1,
                                              constant: 0))
        constraints.append(NSLayoutConstraint(item: eventsTable,
                                              attribute: .trailing,
                                              relatedBy: .equal,
                                              toItem: view,
                                              attribute: .trailing,
                                              multiplier: 1,
                                              constant: 0))
        constraints.append(NSLayoutConstraint(item: eventsTable,
                                              attribute: .centerX,
                                              relatedBy: .equal,
                                              toItem: view,
                                              attribute: .centerX,
                                              multiplier: 1,
                                              constant: 0))
        constraints.append(NSLayoutConstraint(item: eventsTable,
                                              attribute: .bottom,
                                              relatedBy: .equal,
                                              toItem: view,
                                              attribute: .bottom,
                                              multiplier: 1,
                                              constant: 0))
        
        constraints.append(NSLayoutConstraint(item: organizationsTable,
                                              attribute: .top,
                                              relatedBy: .equal,
                                              toItem: tabBar,
                                              attribute: .bottom,
                                              multiplier: 1,
                                              constant: 0))
        constraints.append(NSLayoutConstraint(item: organizationsTable,
                                              attribute: .leading,
                                              relatedBy: .equal,
                                              toItem: view,
                                              attribute: .leading,
                                              multiplier: 1,
                                              constant: 0))
        constraints.append(NSLayoutConstraint(item: organizationsTable,
                                              attribute: .trailing,
                                              relatedBy: .equal,
                                              toItem: view,
                                              attribute: .trailing,
                                              multiplier: 1,
                                              constant: 0))
        constraints.append(NSLayoutConstraint(item: organizationsTable,
                                              attribute: .centerX,
                                              relatedBy: .equal,
                                              toItem: view,
                                              attribute: .centerX,
                                              multiplier: 1,
                                              constant: 0))
        constraints.append(NSLayoutConstraint(item: organizationsTable,
                                              attribute: .bottom,
                                              relatedBy: .equal,
                                              toItem: view,
                                              attribute: .bottom,
                                              multiplier: 1,
                                              constant: 0))
        
        
        NSLayoutConstraint.activate(constraints)
    }
}

extension HomeViewController: MDCTabBarDelegate {
    func tabBar(_ tabBar: MDCTabBar, didSelect item: UITabBarItem) {
        if (item.tag == 1) {
            eventsTable.isHidden = true
            organizationsTable.isHidden = false
        } else {
            eventsTable.isHidden = false
            organizationsTable.isHidden = false
        }
    }
}
