//
//  CartVC.swift
//  SpeechTest
//
//  Created by mac on 12/01/19.
//  Copyright © 2019 jugal balara. All rights reserved.
//

import UIKit

class CartVC: UIViewController, UITableViewDataSource, UITableViewDelegate, SpeakerDelegate {

    @IBOutlet weak var tblView: UITableView!
    
    let listener = Listener()
    var speaker = Speaker()
    
    var listenerAuthorized = false
    
    var isNextScreenShown = false
    
    var listenedText = ""
    
    var couponApplied = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        onClickSpeakNow()
    }
    
    
    //UITableView Datasource & Delegates
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell  : CartTVCell
        if indexPath.row == CartModel.cartItems.count {
            cell = self.tblView.dequeueReusableCell(withIdentifier: "cell1") as! CartTVCell
            cell.setCoupon(couponName: couponApplied)
        }
        else {
            cell = self.tblView.dequeueReusableCell(withIdentifier: "cell") as! CartTVCell
            cell.setCartItem(item: CartModel.cartItems[indexPath.row])
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if CartModel.cartItems.count == 0 {
            return 0
        }
        return CartModel.cartItems.count + 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == CartModel.cartItems.count {
            return 44
        }
        else {
            return 150
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 1 {
            print("Apply Coupon HUNGER100")
        }
    }
    
    func onClickSpeakNow(){
        if listener.isRecording {
            listener.stopRecording()
//            speakNowButton.setTitle("Start Recording", for: .normal)
            return
        }
        speaker.delegate = self
        speaker.speak(text: "couponapply".localizedString())
        //        self.textView.isHidden = false
        //        self.textView.text = "speakrestname".localizedString()
    }
    
    func textDidFinishSpeaking(_ speaker: Speaker, text: String) {
        speaker.delegate = nil
        listenRestName()
    }
    
    func listenRestName(){
//        speakNowButton.setTitle("Stop Recording", for: .normal)
        listener.listen(completion: {
            text, error,isFinal  in
            if text == nil {
                self.showAlert(title: "Error", message: error?.localizedDescription ?? "")
                return
            }
            //            self.textView.text = text
            print(text)
            if isFinal {
                self.listener.stopRecording()
            }
            self.sendToThankyou(text: text!, isFinal: isFinal)
        })
    }
    
    func sendToThankyou(text:String,isFinal:Bool){
        listenedText.append(" \(text)")
        if listenedText.lowercased().contains("back".localizedString()) || listenedText.lowercased().contains("addmore".localizedString()){
            navigationController?.popViewController(animated: true)
            self.listener.stopRecording()
            return
        }
        
        let lastWord = listenedText.components(separatedBy: " ").last?.lowercased()
        if lastWord == "coupon".localizedString() {
            couponApplied = "coupon".localizedString()
            tblView.reloadData()
            speaker.speak(text: "couponallpied".localizedString())
            return
        }
        
        if listenedText.lowercased().contains("confirm".localizedString()) && listenedText.lowercased().contains("order".localizedString()) {
            let destVC : ThankYouVC = (storyboard?.instantiateViewController(withIdentifier: "ThankYouVC") as? ThankYouVC)!
            self.navigationController?.pushViewController(destVC, animated: true)
            listenedText = ""
            self.listener.stopRecording()
            return
        }
        if isFinal {
            listenedText = ""
        }
        
    }
    
    @IBAction func onClickPlaceOrder(_ sender: UIButton) {
        let destVC : ThankYouVC = (storyboard?.instantiateViewController(withIdentifier: "ThankYouVC") as? ThankYouVC)!
        self.navigationController?.pushViewController(destVC, animated: true)
        isNextScreenShown = true
        self.listener.stopRecording()
        listenedText = ""
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
