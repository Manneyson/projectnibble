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
import Kingfisher

class OrganizationsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var headerView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var donationCount: UILabel!
    
    var ref: DatabaseReference!
    
    private var restaurants: [String] = []
    private var organizations: [Organization] = []

    
    var selected: String?
    var indexPath: IndexPath!
    var user: User!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        tableView.register(OrganizationCell.self, forCellReuseIdentifier: "Cell")
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor.flatMint()
        
        self.loadOrganizations()
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
        return self.organizations.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! OrganizationCell
        
        cell.backgroundView?.backgroundColor = UIColor.flatMint()
        cell.myLabel1.text = "\(self.organizations[indexPath.section].name)"
        let url = URL(string: self.organizations[indexPath.section].icon)
        cell.profile.kf.setImage(with: url)
        cell.detail.text = "\(self.organizations[indexPath.section].info)"
        cell.learn.addTarget(self, action: #selector(learnPressed(sender:)), for: .touchUpInside)
        
        return cell
    }
    
    func learnPressed(sender: UIButton!) {
        let cell = sender.superview?.superview as! UITableViewCell
        indexPath = self.tableView.indexPath(for: cell)
        openUrl(urlStr: self.organizations[indexPath.section].url)
    }
    
    func openUrl(urlStr:String!) {
        
        if let url = NSURL(string:urlStr) {
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        }
        
    }
    
    // MARK: - Table view delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! OrganizationCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 200
    }
    
}
