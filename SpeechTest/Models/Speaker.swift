//
//  Speaker.swift
//  SpeechTest
//
//  Created by jugal balara on 12/01/19.
//  Copyright © 2019 jugal balara. All rights reserved.
//

import UIKit
import Speech

class Speaker: NSObject , AVSpeechSynthesizerDelegate{

    static let speechSynthesizer = AVSpeechSynthesizer()
    
    weak var delegate : SpeakerDelegate?
    
    func speak(text:String){
        Speaker.speechSynthesizer.delegate = self
        let speechUtterance = AVSpeechUtterance(string: text)
        Speaker.speechSynthesizer.speak(speechUtterance)
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: {
            timer in
            self.delegate?.textDidFinishSpeaking(self, text: utterance.speechString)
        })
//        synthesizer.
    }
    
}

protocol SpeakerDelegate: NSObjectProtocol {
    func textDidFinishSpeaking(_ speaker : Speaker,text:String)
    
}
