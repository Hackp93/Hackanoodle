//
//  ThankYouVC.swift
//  SpeechTest
//
//  Created by mac on 12/01/19.
//  Copyright © 2019 jugal balara. All rights reserved.
//

import UIKit

class ThankYouVC: UIViewController,SpeakerDelegate {

    var listenedText = ""
    
    let listener = Listener()
    var speaker = Speaker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CartModel.cartItems.removeAll()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        speaker.delegate = self
        speaker.speak(text: "success".localizedString())
    }
    
    @IBAction func onClickGoToHome(_ sender: UIButton) {
        //let destVC : HomeVC = (storyboard?.instantiateViewController(withIdentifier: "HomeVC") as? HomeVC)!
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func textDidFinishSpeaking(_ speaker: Speaker, text: String) {
        speaker.delegate = nil
        listenRestName()
    }
    
    func listenRestName(){
        listener.listen(completion: {
            text, error,isFinal  in
            if text == nil {
                self.showAlert(title: "Error", message: error?.localizedDescription ?? "")
                return
            }
            
            print(text)
            if isFinal {
                self.listener.stopRecording()
            }
            self.sendToThankyou(text: text!, isFinal: isFinal)
        })
    }

    func sendToThankyou(text:String,isFinal:Bool){
        listenedText.append(" \(text)")
        if listenedText.lowercased().contains("home".localizedString()) {
            navigationController?.popToRootViewController(animated: true)
            self.listener.stopRecording()
            return
        }
        
        
        if isFinal {
            listenedText = ""
        }
        
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
