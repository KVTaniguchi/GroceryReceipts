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
    
    func startRecording(completion: @escaping (Error?) -> Void ) {
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryRecord)
            try audioSession.setMode(AVAudioSessionModeMeasurement)
            try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        }
        catch {
            completion(error)
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        guard let inputNode = audioEngine.inputNode else {
            completion(SpeechErrors.noInputNode)
            return
        }
        
        guard let recognitionRequest = recognitionRequest else {
            completion(SpeechErrors.noRecognitionRequest)
            return
        }
        
        recognitionRequest.shouldReportPartialResults = true
        
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { [unowned self] (result, error) in
            
            guard let result = result else {
                if let err = error {
                    self.audioEngine.stop()
                    inputNode.removeTap(onBus: 0)
                    self.recognitionRequest = nil
                    self.recognitionTask = nil
                    completion(err)
                }
                return
            }
            
            print("REUSLT \(result.bestTranscription.formattedString)")
        })
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
        }
        catch {
            completion(error)
        }
    }
    
    
}
