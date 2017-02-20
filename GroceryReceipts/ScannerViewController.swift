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
        
        CameraManager.shared.handlePhotoOperation(title: "Get some", presentingViewController: self)
        
        
        
    }
}



