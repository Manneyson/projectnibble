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

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var profileCardImage: UIImageView!
    @IBOutlet weak var profileCard: UIView!
    var user: String!
    @IBOutlet weak var close: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.flatMint()
        
        let label = SACountingLabel(frame: CGRect(x: self.profileCardImage.frame.midX + 25, y: self.profileCardImage.frame.height + 100, width: 200, height: 100))
        label.font = UIFont(name: "Avenir-Heavy", size: 25)
        label.countFrom(fromValue: 0, to: 100, withDuration: 1.0, andAnimationType: .EaseIn, andCountingType: .Int)
        label.textAlignment = .center
        self.view.addSubview(label)
        
        
        close.setImage(UIImage(named: "close"), for: .normal)
        close.addTarget(self, action: #selector(closePressed(_:)), for: UIControlEvents.touchUpInside)
        
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
