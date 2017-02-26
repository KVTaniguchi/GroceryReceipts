//
//  TabNavController.swift
//  GroceryReceipts
//
//  Created by Kevin Taniguchi on 2/19/17.
//  Copyright © 2017 Kevin Taniguchi. All rights reserved.
//

import UIKit

class TabNavController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scanner = ScannerViewController()
        let tabOne = UITabBarItem(title: "Scan", image: nil, selectedImage: nil)
        scanner.tabBarItem = tabOne
        
        viewControllers = [scanner]
    }
}
