//
//  SpeechManager.swift
//  GroceryReceipts
//
//  Created by Kevin Taniguchi on 2/26/17.
//  Copyright © 2017 Kevin Taniguchi. All rights reserved.
//

import Foundation
import Speech

class SpeechManager: NSObject, SFSpeechRecognizerDelegate {

    enum SpeechErrors: Error {
        case noInputNode
        case noRecognitionRequest
    }
    
    static let shared = SpeechManager()
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.current)
    
    private(set) var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    let audioEngine = AVAudioEngine()
    
    override init() {
        super.init()
        speechRecognizer?.delegate = self
    }
    
    func requestSpeechAuth(completion: @escaping (Bool) -> Void) {
        SFSpeechRecognizer.requestAuthorization { (status) in
            completion(status == .authorized)
        }
    }
    
    func startRecording() throws {
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(AVAudioSessionCategoryRecord)
        try audioSession.setMode(AVAudioSessionModeMeasurement)
        try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        guard let inputNode = audioEngine.inputNode else {
            throw SpeechErrors.noInputNode
        }
        
        guard let recognitionRequest = recognitionRequest else {
            throw SpeechErrors.noRecognitionRequest
        }
        
        recognitionRequest.shouldReportPartialResults = true
        
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { [unowned self] (result, error) in
            
            var isFinal = false
            
            if let result = result {
                // TODO Process strings into model
                print(result.bestTranscription.formattedString)
                isFinal = result.isFinal
                if result.isFinal {
                    print("IS FINAL")
                }
            }
            
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
            }
        })
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        
        try audioEngine.start()
    }
    
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        print("AVAIL CHANGE \(available)")
    }
}
