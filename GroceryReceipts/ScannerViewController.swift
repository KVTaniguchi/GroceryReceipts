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
        
        SpeechManager.shared.requestSpeechAuth { (authed) in
            
        }
        
        view.backgroundColor = UIColor.lightGray
        
        let button = UIButton(type: .custom)
        button.setTitle("SCAN", for: .normal)
        button.addTarget(self, action: #selector(scanButtonPressed), for: .touchUpInside)
        
        let mic = UIButton(type: .custom)
        mic.setTitle("MIC", for: .normal)
        mic.addTarget(self, action: #selector(micButtonPressed), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        
        mic.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mic)
        mic.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mic.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 100).isActive = true
    }
    
    func scanButtonPressed() {
        CameraManager.shared.handlePhotoOperation(title: "Get some", presentingViewController: self)
    }
    
    func micButtonPressed() {
        if SpeechManager.shared.audioEngine.isRunning {
           SpeechManager.shared.audioEngine.stop()
           SpeechManager.shared.recognitionRequest?.endAudio()
        }
        else {
           SpeechManager.shared.startRecording(completion: { (err) in
                print("ERRR \(err)")
           })
        }
    }
}



