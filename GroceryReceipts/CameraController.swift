//
//  CameraController.swift
//  GroceryReceipts
//
//  Created by Kevin Taniguchi on 2/19/17.
//  Copyright © 2017 Kevin Taniguchi. All rights reserved.
//

import Foundation

import Foundation
import UIKit
import Photos
import AVFoundation
import MobileCoreServices
import TesseractOCR

typealias BoolCallback = (Bool) -> ()

class CameraManager: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate, G8TesseractDelegate {
    static let shared = CameraManager()
    let tesseract = G8Tesseract(language: "eng")
    fileprivate let imagePickerController = UIImagePickerController()
    
    fileprivate override init() {
        super.init()
        
        imagePickerController.delegate = self
        imagePickerController.mediaTypes = [kUTTypeImage as String]
        imagePickerController.allowsEditing = false
        imagePickerController.sourceType = .camera
        imagePickerController.showsCameraControls = true
    }
    
    func handlePhotoOperation(title: String, presentingViewController: UIViewController) {
        checkCameraAuthAccess {[unowned self] (granted) in
            if granted && UIImagePickerController.isSourceTypeAvailable(.camera) {
                DispatchQueue.main.async {
                    presentingViewController.present(self.imagePickerController, animated: true, completion: nil)
                }
            }
            else {
                let alertController = UIAlertController(title: "No Camera", message: "Grocery Receipt requires a device with a camera with camera permissions.", preferredStyle: .alert)
                presentingViewController.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let imageKeys = Set([UIImagePickerControllerOriginalImage])
        let allKeysSet = Set(info.keys)
        let intersect = imageKeys.intersection(allKeysSet)
        
        guard let imageKey = intersect.first, let image = info[imageKey] as? UIImage else { return }
        
        tesseract?.image = image
        
        tesseract?.recognize()
        
        if let text = tesseract?.recognizedText {
            let separatedStrings = text.components(separatedBy: "\n").filter{!$0.isEmpty}
            
            for string in separatedStrings {
                print("RESULT: \(string)")
            }
        }
        
        picker.dismiss(animated: true) { 
            
        }
    }
    
    private func checkCameraAuthAccess(callBack: @escaping BoolCallback) {
        let status = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        switch status {
        case .authorized:
            callBack(true)
        case .notDetermined:
            AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: { (granted) in
                callBack(granted)
            })
        case .denied, .restricted:
            callBack(false)
        }
    }
}
