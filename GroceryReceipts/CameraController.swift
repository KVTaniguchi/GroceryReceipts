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
        
        
        
        print("MY ESS \(tesseract)")
    }
    
    func handlePhotoOperation(title: String, presentingViewController: UIViewController) -> String? {
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
        
        return ""
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let imageKeys = Set([UIImagePickerControllerOriginalImage])
        let allKeysSet = Set(info.keys)
        let intersect = imageKeys.intersection(allKeysSet)
        
        guard let imageKey = intersect.first, let image = info[imageKey] as? UIImage else { return }
        
        tesseract?.image = image
        
        tesseract?.recognize()

        print("******* \(tesseract)")
        print("iage \(image)")
        
        print("TEXT: \(tesseract?.recognizedText)")
        
        
        var aTesseract:G8Tesseract = G8Tesseract(language:"eng+ita")
        
        print(aTesseract)
        
        aTesseract.image = image
        aTesseract.recognize()
        print(aTesseract.recognizedText)
        
        print("*******")
        
        // TODO use a different OCR
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

    
    //    - (void)storeLanguageFile {
    //
    //    NSFileManager *fileManager = [NSFileManager defaultManager];
    //    NSString *docsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    //    NSString *path = [docsDirectory stringByAppendingPathComponent:@"/tessdata/eng.traineddata"];
    //    if(![fileManager fileExistsAtPath:path])
    //    {
    //    NSData *data = [NSData dataWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingString:@"/tessdata/eng.traineddata"]];
    //    NSError *error;
    //    [[NSFileManager defaultManager] createDirectoryAtPath:[docsDirectory stringByAppendingPathComponent:@"/tessdata"] withIntermediateDirectories:YES attributes:nil error:&error];
    //    [data writeToFile:path atomically:YES];
    //    }
    //    }
    
    let file = "file.txt" //this is the file. we will write to and read from it
    
    let text = "some text" //just a text
    
//    if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
//        
//        let path = dir.appendingPathComponent(file)
//        
//        //writing
//        do {
//            try text.write(to: path, atomically: false, encoding: String.Encoding.utf8)
//        }
//        catch {/* error handling here */}
//        
//        //reading
//        do {
//            let text2 = try String(contentsOf: path, encoding: String.Encoding.utf8)
//        }
//        catch {/* error handling here */}
//    }
    
    func storeLang() {
        let fileManager = FileManager.default
        guard let docsDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else { return }
        let path = docsDir.appending("/tessdata/eng.traineddata")
        if !fileManager.fileExists(atPath: path), let path = Bundle.main.resourcePath?.appending("/tessdata/eng.traineddata") {
            let data = fileManager.contents(atPath: path)
            fileManager.createFile(atPath: docsDir.appending("/tessdata"), contents: data, attributes: nil)
        }
    }
    

//    
//    - (NSString *)scanImage:(UIImage *)image {
//    
//    Tesseract *tesseract = [[Tesseract alloc] initWithDataPath:@"/tessdata" language:@"eng"];
//    
//    [tesseract setVariableValue:@"0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ" forKey:@"tessedit_char_whitelist"];
//    [tesseract setVariableValue:@".,:;'" forKey:@"tessedit_char_blacklist"];
//    
//    if (image) {
//    [tesseract setImage:image];
//    [tesseract setRect:CGRectMake(0, point.y- 25, image.size.width, 50)];
//    [tesseract recognize];
//    return [tesseract recognizedText];
//    }
//    return nil;
//    }
}
