//
//  ViewController.swift
//  SpeechTest
//
//  Created by jugal balara on 12/01/19.
//  Copyright © 2019 jugal balara. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let listener = Listener()
    var speaker = Speaker()
    
    var listenerAuthorized = false

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var microphoneButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listener.requestAuthorization(completion: {
            status in
            if status == .Success {
                self.listenerAuthorized = true
            }
            //self.speaker.speak(text: "introduction".localizedString())
        })
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func microphoneTapped(_ sender: AnyObject) {
        if listener.isRecording {
            listener.stopRecording()
            microphoneButton.setTitle("Start Recording", for: .normal)
            return
        }
        microphoneButton.setTitle("Stop Recording", for: .normal)
        listener.listen(completion: {
            text, error,isFinal  in
            if text == nil {
                self.showAlert(title: "Error", message: error?.localizedDescription ?? "")
                return
            }
            self.textView.text = text
        })
    }
}

