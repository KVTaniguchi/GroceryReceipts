//
//  ScannerViewController.swift
//  GroceryReceipts
//
//  Created by Kevin Taniguchi on 2/19/17.
//  Copyright © 2017 Kevin Taniguchi. All rights reserved.
//

import UIKit
import Photos

class ScannerViewController: UIViewController {

    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.lightGray
        
        let button = UIButton(type: .custom)
        button.setTitle("SCAN", for: .normal)
        button.addTarget(self, action: #selector(scanButtonPressed), for: .touchUpInside)
        
        
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -80).isActive = true
    }
    
    func scanButtonPressed() {
        CameraManager.shared.handlePhotoOperation(title: "Get some", presentingViewController: self)
    }
}



