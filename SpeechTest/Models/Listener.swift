//
//  Listener.swift
//  SpeechTest
//
//  Created by jugal balara on 12/01/19.
//  Copyright © 2019 jugal balara. All rights reserved.
//

import UIKit
import Speech

class Listener: NSObject {

    
    static private let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer(locale: Locale(identifier: "en-IN"))
    
    static private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    static private var recognitionTask: SFSpeechRecognitionTask?
    static private let audioEngine = AVAudioEngine()
    
    var isRecording : Bool {
        return Listener.audioEngine.isRunning
    }
    
    func stopRecording(){
        //Listener.recognitionRequest?.endAudio()
        if isRecording {
            Listener.audioEngine.stop()
            Listener.audioEngine.inputNode.removeTap(onBus: 0)
            Listener.recognitionTask?.cancel()
            Listener.recognitionTask = nil
        }
    }
    
    func listen(completion :@escaping (String?,Error?,Bool)->Void){
        
        if Listener.recognitionTask != nil {
            Listener.recognitionTask?.cancel()
            Listener.recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playAndRecord, mode: .measurement, options: .defaultToSpeaker)//setCategory(AVAudioSession.Category.record)
            //try audioSession.setMode(AVAudioSession.Mode.measurement)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            completion(nil,ListenerError.propertiesNotSet, true)
            print("audioSession properties weren't set because of an error.")
            return
        }
        
        Listener.recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        //        guard let inputNode = audioEngine.inputNode else {
        //            fatalError("Audio engine has no input node")
        //        }
        let inputNode = Listener.audioEngine.inputNode
        
        guard let recognitionRequest = Listener.recognitionRequest else {
            completion(nil,ListenerError.bufferERROR, true)
            return
            //fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        
        recognitionRequest.shouldReportPartialResults = true
       // recognitionRequest.
        
        Listener.recognitionTask = Listener.speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            
            var isFinal = false
            
            if result != nil {
                isFinal = (result?.isFinal)!
                completion(result?.bestTranscription.formattedString,nil, isFinal)
            }
            
            if error != nil || isFinal {
                Listener.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                Listener.recognitionRequest = nil
                Listener.recognitionTask = nil
                
            }
        })
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 50, format: recordingFormat) { (buffer, when) in
            Listener.recognitionRequest?.append(buffer)
        }
        
        Listener.audioEngine.prepare()
        
        do {
            try Listener.audioEngine.start()
        } catch {
            completion(nil,ListenerError.bufferERROR, true)
            print("audioEngine couldn't start because of an error.")
        }
        
    }
    
    func requestAuthorization(completion :@escaping (AuthorizationStatus)->Void){
        SFSpeechRecognizer.requestAuthorization({
            status in
            if status == SFSpeechRecognizerAuthorizationStatus.authorized {
                DispatchQueue.main.async {
                    completion(AuthorizationStatus.Success)
                }
            } else {
                DispatchQueue.main.async {
                    completion(AuthorizationStatus.Failed)
                }
            }
        })
    }
    
}

enum AuthorizationStatus {
    case Success
    case Failed
}

enum ListenerError: Error {
    case audioEngineFailed
    case bufferERROR
    case propertiesNotSet
}
