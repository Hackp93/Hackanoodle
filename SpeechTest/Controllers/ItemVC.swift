//
//  ItemVC.swift
//  SpeechTest
//
//  Created by mac on 12/01/19.
//  Copyright © 2019 jugal balara. All rights reserved.
//

import UIKit

class ItemVC: UIViewController, UITableViewDataSource, UITableViewDelegate, SpeakerDelegate, UISearchBarDelegate {

    @IBOutlet weak var tblViewItems: UITableView!
    @IBOutlet weak var speakNowButton : UIButton!

    @IBOutlet weak var heightSearchBar: NSLayoutConstraint!


    let listener = Listener()
    var speaker = Speaker()
    
    var listenerAuthorized = false
    
    var isNextScreenShown = false
    
    var listenedText = ""

    var dataRestaurant : ModelClass?
    var allItems = [ItemModel]()
    
    var isSearching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = dataRestaurant?.restName
        
        allItems = (dataRestaurant?.items)!
        heightSearchBar.constant = 0
        onClickSpeakNow(speakNowButton)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isNextScreenShown = false
        onClickSpeakNow(speakNowButton)
    }
    
    //UITableView Datasource & Delegates
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell  : ItemTVCell = self.tblViewItems.dequeueReusableCell(withIdentifier: "cell") as! ItemTVCell
        cell.setValues(dict: allItems[indexPath.row])
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allItems.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.listener.stopRecording()
        CartModel.cartItems.append((allItems[indexPath.row]))
        let destVC : CartVC = (storyboard?.instantiateViewController(withIdentifier: "CartVC") as? CartVC)!
        self.navigationController?.pushViewController(destVC, animated: true)
        isNextScreenShown = true
        listenedText = ""
    }
    
    @IBAction func onClickSpeakNow(_ sender : UIButton){
        if listener.isRecording {
            listener.stopRecording()
            speakNowButton.setTitle("Start Recording", for: .normal)
            return
        }
        speaker.delegate = self
        speaker.speak(text: "speakitemname".localizedString())
        //        self.textView.isHidden = false
        //        self.textView.text = "speakrestname".localizedString()
    }

    func textDidFinishSpeaking(_ speaker: Speaker, text: String) {
        speaker.delegate = nil
        listenRestName()
    }
    
    func sentToMenu(forRest rest : String,isFinal:Bool) {
        
        if isSearching {
            searchRestName(text: rest)
            return
        }
        
        if listenedText.lowercased().contains("search".localizedString().lowercased()) {
            isSearching = true
            searchRestName(text: rest)
            return
        }
        
        listenedText.append(" \(rest)")
        if listenedText.lowercased().contains("back".localizedString()) {
            navigationController?.popViewController(animated: true)
            listenedText = ""
            self.listener.stopRecording()
            return
        }
        
        if isShowCart(text: listenedText) {
            let next = storyboard?.instantiateViewController(withIdentifier: "CartVC")
            navigationController?.pushViewController(next!, animated: true)
            listenedText = ""
            self.listener.stopRecording()
            return
        }
        let lastWord = rest.components(separatedBy: " ").last

        let filteredList = dataRestaurant?.items.filter({
            name in
            return name.name.lowercased().contains(lastWord!.lowercased()) || name.category.lowercased().contains(rest.lowercased())
        })
        
        if filteredList!.isEmpty {
            if isFinal {
                speaker.speak(text: rest + " " + "restaurantnotfound".localizedString())
                listenedText = ""
            }
            //onClickSpeakNow(speakNowButton)
            //            textView.text = "restaurantnotfound".localizedString()
        } else {
            if !isNextScreenShown {
                CartModel.cartItems.append((filteredList?.first!)!)
                let next = storyboard?.instantiateViewController(withIdentifier: "CartVC")
                navigationController?.pushViewController(next!, animated: true)
                isNextScreenShown = true
                listenedText = ""
                self.listener.stopRecording()
                return
            }
        }
        
        if isFinal {
            listenedText = ""
        }
    }
    
    func listenRestName(){
        speakNowButton.setTitle("Stop Recording", for: .normal)
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
            self.sentToMenu(forRest: text ?? "", isFinal: isFinal)
        })
    }
    
    // Searchbar Delegates
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !(searchBar.text?.isEmpty)! {
            let filteredUsers = allItems.filter({
                user in
                let dict = user
                let text = dict.name.lowercased()
                let text1 = dict.category.lowercased()
                return text.contains("\(searchBar.text?.lowercased() ?? "")") || text1.contains("\(searchBar.text?.lowercased() ?? "")")
            })
            if filteredUsers.isEmpty {
                //noMatchLabel.isHidden = false
                tblViewItems.isHidden = true
            } else {
                //noMatchLabel.isHidden = true
                tblViewItems.isHidden = false
            }
            dataRestaurant?.items = NSMutableArray(array: filteredUsers) as! [ItemModel]
            tblViewItems.reloadData()
        } else {
            tblViewItems.isHidden = false
            //noMatchLabel.isHidden = true
            dataRestaurant?.items = allItems
            tblViewItems.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchRestName(text:String){
        heightSearchBar.constant = 56
        let nameWithSpaces = text.lowercased().replacingOccurrences(of: listenedText.lowercased(), with: "")
        
        if nameWithSpaces.lowercased().contains("show".localizedString().lowercased()) || nameWithSpaces.lowercased().contains("cancel".localizedString().lowercased()) {
            allItems = ((dataRestaurant?.items)!)
            tblViewItems.reloadData()
            isSearching = false
            listenedText = ""
            self.listener.stopRecording()
            self.onClickSpeakNow(self.speakNowButton)
            heightSearchBar.constant = 0
            return
        }
        let lastword = nameWithSpaces.components(separatedBy: " ").last
        
        if lastword == "search".localizedString().lowercased() {
            allItems = ((dataRestaurant?.items)!)
            tblViewItems.reloadData()
            return
        }
        
        allItems = (dataRestaurant?.items)!.filter({
            restaur in
            return restaur.name.lowercased().contains(lastword!.lowercased())
        })
        tblViewItems.reloadData()
        //listenedText = "search".localizedString()
        print("searched \(nameWithSpaces)")
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
