//
//  TextToSpeechViewController.swift
//  SpeechTest
//
//  Created by jugal balara on 12/01/19.
//  Copyright © 2019 jugal balara. All rights reserved.
//

import UIKit
import Speech

class TextToSpeechViewController: UIViewController {

    @IBOutlet weak var textView : UITextView!
    
    let speechSynthesizer = AVSpeechSynthesizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onClickConvert(_ sender : UIButton){
        let speechUtterance = AVSpeechUtterance(string: textView.text ?? "")
        
        speechSynthesizer.speak(speechUtterance)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
