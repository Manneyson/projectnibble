//
//  TabBarController.swift
//  Nibble
//
//  Created by Sawyer Billings on 9/25/17.
//  Copyright © 2017 Sawyer Billings. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let restaurantViewController = RestaurantViewController()
        restaurantViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .downloads, tag: 0)
        let menuViewController = ViewController()
        menuViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .bookmarks, tag: 1)
        let viewControllerList = [ restaurantViewController, menuViewController ]
        viewControllers = viewControllerList.map { UINavigationController(rootViewController: $0) }
    }
}
