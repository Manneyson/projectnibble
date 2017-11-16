////
////  ViewController.swift
////  UEats
////
////  Created by Sawyer Billings on 8/15/17.
////  Copyright © 2017 Sawyer Billings. All rights reserved.
////
//
//import UIKit
//import MXParallaxHeader
//import Firebase
//import PopupDialog
//import GMStepper
//import SCLAlertView
//import Kingfisher
//
//
////
////  ViewController.swift
////  UEats
////
////  Created by Sawyer Billings on 8/15/17.
////  Copyright © 2017 Sawyer Billings. All rights reserved.
////
//
//import UIKit
//import Firebase
//
//class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
//
//    @IBOutlet weak var close: UIButton!
//
//    @IBOutlet weak var checkout: UIButton!
//
//    @IBOutlet weak var tableView: UITableView!
//    @IBOutlet weak var headerImage: UIImageView!
//    @IBOutlet var restaurantHeader: UIView!
//    var restaurant: Restaurant?
//    var organizations: [Organization] = []
//    var organizationSelected: Organization?
//    var destination: String?
//    let settingsVC = SettingsViewController()
//    var indexPath: IndexPath!
//    var shoppingCart : [Item] = []
//    //var total = 0
//    var ref: DatabaseReference!
//    var counter : [String] = []
//
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        let hud = HUD.showLoading()
//        let items = Database.database().reference().child("menu")
//        items.observe(.value, with: { snapshot in
//            for item in snapshot.children.allObjects as! [DataSnapshot] {
//                let menuObject = item.value as? [String: AnyObject]
//                if ((menuObject?["restaurant"] as! String).contains(self.restaurant!.name)) {
//                    self.counter.append("found")
//                }
//            }
//            hud.dismiss()
//            self.tableView.reloadData()
//        })
//
//
//        checkout.backgroundColor = UIColor.black
//        checkout.layer.cornerRadius = 7
//
//        // Parallax Header
//        checkout.addTarget(self, action: #selector(checkoutPressed(_:)), for: .touchUpInside)
//        close.addTarget(self, action: #selector(closePressed(_:)), for: .touchUpInside)
//
//        let url = URL(string: (self.restaurant?.header)!)
//        headerImage.kf.setImage(with: url)
//        tableView.delegate = self
//        tableView.register(MenuItemCell.self, forCellReuseIdentifier: "Cell")
//        tableView.separatorStyle = .singleLine
//        tableView.dataSource = self
//        tableView.delegate = self
//        tableView.backgroundColor = UIColor.white
//        close.addTarget(self, action: #selector(closePressed(_:)), for: UIControlEvents.touchUpInside)
//        close.tintColor = UIColor.white
//
//        loadOrganizations()
//        tableView.reloadData()
//    }
//
//    func loadOrganizations() {
//        let hud = HUD.showLoading()
//        let organizations = Database.database().reference().child("organizations")
//        organizations.observe(DataEventType.value, with: { (snapshot) in
//            if (snapshot.childrenCount > 0) {
//                for entries in snapshot.children.allObjects as! [DataSnapshot] {
//                    let spot = entries.value as? [String: AnyObject]
//                    self.organizations.append(Organization(name: spot?["name"] as! String, info: spot?["info"] as! String, icon: spot?["icon"] as! String, stripe: spot?["stripe"] as! String))
//                }
//            }
//            self.tableView.reloadData()
//            hud.dismiss()
//        })
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
//    {
//        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 30))
//        headerView.backgroundColor = UIColor.clear
//        return headerView
//    }
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return self.counter.count
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let cell = tableView.cellForRow(at: indexPath) as! RestaurantCell
//        cell.selectionStyle = UITableViewCellSelectionStyle.none
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! MenuItemCell
//        var names : [String] = []
//        var details: [String] = []
//        var prices: [Int] = []
//        var attributes: [[Int]] = [[]]
//
//        let items = Database.database().reference().child("menu")
//        items.observe(DataEventType.value, with: { (snapshot) in
//            if (snapshot.childrenCount > 0) {
//                for item in snapshot.children.allObjects as! [DataSnapshot] {
//                    let menuObject = item.value as? [String: AnyObject]
//                    let currRestaurant = menuObject?["restaurant"] as! String
//                    if (currRestaurant == self.restaurant?.name) {
//                        names.append(menuObject?["name"] as! String)
//                        details.append(menuObject?["description"] as! String)
//                        prices.append(menuObject?["price"] as! Int)
//                        if (menuObject?["attributes"] != nil) {
//                            attributes.append(menuObject?["attributes"] as! [Int])
//                        } else {
//                            attributes.append([99999])
//                        }
//                    } else {
//                        continue
//                    }
//                }
//
//                cell.myLabel1.text = names[indexPath.section]
//                cell.addButton.addTarget(self, action: #selector(self.addPressed(_:)), for: UIControlEvents.touchUpInside)
//                cell.details.text = details[indexPath.section]
//                cell.attributes = [attributes[indexPath.section + 1]]
//                if (self.shoppingCart.contains(where: {$0.name == cell.myLabel1.text!})) {
//                    let item = self.shoppingCart.first(where: { $0.name == cell.myLabel1.text!})
//                    cell.addButton.setImage(UIImage(named: "cancel"), for: .normal)
//                    cell.quantity.isHidden = false
//                    cell.quantityLabel.text = "\(item?.quantity ?? 0) x "
//                } else {
//                    cell.addButton.setImage(UIImage(named: "icons8-add_filled"), for: .normal)
//                    cell.quantity.isHidden = true
//                    cell.quantityLabel.text = ("")
//                }
//                cell.quantity.addTarget(self, action: #selector(self.quantityPressed(_:)), for: .touchUpInside)
//
//
//                //we store an array of attribute arrays. '99999' indicates an object without attributes
//                if (cell.attributes[0][0] == 99999) {
//                    cell.attributes = nil
//                    cell.price.isHidden = false
//                    cell.price.setTitle("$\((prices[indexPath.section]/100) + 1)", for: .normal)
//                    cell.price.titleLabel!.font =  UIFont(name: "Avenir-Book", size: 13)
//                    cell.cost = prices[indexPath.section]
//                } else {
//                    if (self.shoppingCart.contains(where: {$0.name == cell.myLabel1.text!})) {
//                        let item = self.shoppingCart.first(where: { $0.name == cell.myLabel1.text!})
//                        cell.price.setTitle("$\(((item?.price)! / 100) + 1)", for: .normal)
//                        cell.price.titleLabel!.font =  UIFont(name: "Avenir-Book", size: 13)
//                        cell.price.isHidden = false
//                    } else {
//                        cell.price.setTitle("$\((cell.attributes[0][2]/100) + 1) - \((cell.attributes[0][0]/100) + 1)", for: .normal)
//                        cell.price.titleLabel!.font =  UIFont(name: "Avenir-Book", size: 10)
//                    }
//                }
//            }
//        })
//
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
//    {
//        return 165
//    }
//
//
//    func closePressed(_ sender: UIButton!){
//        self.dismiss(animated: true, completion: nil)
//    }
//
//    func convertOrderDetails(order: [Item]) -> [String] {
//        var orderString: [String] = []
//        for item in order {
//            orderString.append("\(item.name) [\(item.quantity)][\(item.size)]")
//        }
//        return orderString
//    }
//
//    func getOrderTotal(order: [Item]) -> Int {
//        var totalPrice = 0
//        for item in order {
//            totalPrice += item.price
//        }
//        return totalPrice
//    }
//
//    func checkoutPressed(_ sender:UIButton!){
//
//        if (shoppingCart.count != 0) {
//            //this will need to pull up the entire list of organizations
//            let alertView = SCLAlertView()
//            for org in self.organizations {
//                alertView.addButton("\(org.name)")  {
//                    self.organizationSelected = org
//                    let checkoutViewController = CheckoutViewController(product: self.restaurant!.name,
//                                                                        price: self.getOrderTotal(order: self.shoppingCart),
//                                                                        settings: self.settingsVC.settings,
//                                                                        order: self.convertOrderDetails(order: self.shoppingCart),
//                                                                        restaurant: self.restaurant!,
//                                                                        organization: (self.organizationSelected ?? nil)!)
//                    self.present(checkoutViewController, animated: true)
//                }
//            }
//            alertView.showSuccess(
//                "Organization Selection",
//                subTitle: "Please select a non profit",
//                colorStyle: 0x00000)
//        }
//
//    }
//
//    func quantityPressed(_ sender: UIButton!) {
//        let cell = sender.superview?.superview as! MenuItemCell
//        indexPath = self.tableView.indexPath(for: cell)
//
//        //increment the quantity and price of the item in our shopping cart
//
//        shoppingCart.first(where: { $0.name == cell.myLabel1.text! })?.quantity += 1
//        shoppingCart.first(where: { $0.name == cell.myLabel1.text! })?.price += cell.cost!
//
//        cell.quantityLabel.text = ("\(shoppingCart.first(where: { $0.name == cell.myLabel1.text! })?.quantity ?? 0) x ")
//        //cell.quantityLabel.isHidden = false
//    }
//
//    func addPressed(_ sender:UIButton!){
//        let cell = sender.superview?.superview as! MenuItemCell
//        indexPath = self.tableView.indexPath(for: cell)
//
//
//        if (cell.attributes != nil) {
//            if (shoppingCart.contains(where: { $0.name == cell.myLabel1.text! })){
//                for item in shoppingCart {
//                    if item.name == cell.myLabel1.text! {
//                        let index = shoppingCart.index(where: { (item) -> Bool in
//                            item.name == cell.myLabel1.text!
//                        })
//                        shoppingCart.remove(at: index!)
//                    }
//                }
//                self.tableView.reloadData()
//            } else {
//                let title = "Customize Your Order"
//                let message = "Please choose a size."
//
//                let popup = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
//
//                let large = UIAlertAction(title: "Large", style: .default, handler: {
//                    (alert: UIAlertAction!) -> Void in
//                    cell.cost = cell.attributes[0][0]
//                    self.shoppingCart.append(Item(name: cell.myLabel1.text!, price: cell.attributes[0][0], size: "L", quantity: 1, index: self.indexPath))
//                    self.tableView.reloadData()
//                })
//
//                let medium = UIAlertAction(title: "Medium", style: .default, handler: {
//                    (alert: UIAlertAction!) -> Void in
//                    cell.cost = cell.attributes[0][1]
//                    self.shoppingCart.append(Item(name: cell.myLabel1.text!, price: cell.attributes[0][1], size: "M", quantity: 1, index: self.indexPath))
//                    self.tableView.reloadData()
//                })
//
//                let small = UIAlertAction(title: "Small", style: .default, handler: {
//                    (alert: UIAlertAction!) -> Void in
//                    cell.cost = cell.attributes[0][2]
//                    self.shoppingCart.append(Item(name: cell.myLabel1.text!, price: cell.attributes[0][2], size: "S", quantity: 1, index: self.indexPath))
//                    self.tableView.reloadData()
//                })
//
//                let close = UIAlertAction(title: "Cancel", style: .cancel, handler: {
//                    (alert: UIAlertAction!) -> Void in
//                })
//
//                popup.addAction(large)
//                popup.addAction(medium)
//                popup.addAction(small)
//                popup.addAction(close)
//
//                self.present(popup, animated: true, completion: nil)
//            }
//        } else {
//            if (shoppingCart.contains(where: { $0.name == cell.myLabel1.text! })){
//                for item in shoppingCart {
//                    if item.name == cell.myLabel1.text! {
//                        let index = shoppingCart.index(where: { (item) -> Bool in
//                            item.name == cell.myLabel1.text!
//                        })
//                        shoppingCart.remove(at: index!)
//                    }
//                }
//                self.tableView.reloadData()
//            } else {
//                shoppingCart.append(Item(name: cell.myLabel1.text!, price: cell.cost, size: "N/A", quantity: 1, index: self.indexPath))
//                self.tableView.reloadData()
//            }
//        }
//    }
//
//}
//
//
//
