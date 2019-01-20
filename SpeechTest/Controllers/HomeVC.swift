//
//  HomeVC.swift
//  SpeechTest
//
//  Created by mac on 12/01/19.
//  Copyright © 2019 jugal balara. All rights reserved.
//

import UIKit

class HomeVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var tblViewHome: UITableView!
    @IBOutlet weak var speakNowButton : UIButton!
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var heightSearchBar: NSLayoutConstraint!
    
    
    let listener = Listener()
    var speaker = Speaker()
    var listenerAuthorized = false
    var isNextScreenShown = false
    
    var listenedText = ""
    
    //var restNames = ["Royal Bakery","hotel","Restaurant"]
    //var restaurant = [Restaurant]()
    var restaurant = [ModelClass]()
    var allRrestaurant = [ModelClass]()
    
    var isSearching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUpNavigationBar()
        
        heightSearchBar.constant = 0
        
        restaurant = ModelClass.getRestaurantList(restaurantDict: restaurentArray)
        print(restaurant)
        
        allRrestaurant = restaurant
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isNextScreenShown = false
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        listener.requestAuthorization(completion: {
            status in
            if status == .Success {
                self.listenerAuthorized = true
                //self.speaker.speak(text: "introduction".localizedString())
                self.onClickSpeakNow(self.speakNowButton)
            }
        })
        
    }
    
    
    //UITableView Datasource & Delegates
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell  : HomeCustomTableViewCell = self.tblViewHome.dequeueReusableCell(withIdentifier: "cell") as! HomeCustomTableViewCell
        
        cell.setValues(dict: restaurant[indexPath.row])
        
        return cell
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurant.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.listener.stopRecording()
        let destVC : ItemVC = (storyboard?.instantiateViewController(withIdentifier: "ItemVC") as? ItemVC)!
        destVC.dataRestaurant = restaurant[indexPath.row]
        self.navigationController?.pushViewController(destVC, animated: true)
        isNextScreenShown = true
        listenedText = ""
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onClickSpeakNow(_ sender : UIButton){
        if listener.isRecording {
            listener.stopRecording()
            speakNowButton.setTitle("Start Recording", for: .normal)
            return
        }
        speaker.delegate = self
        speaker.speak(text: "speakrestname".localizedString())
//        self.textView.isHidden = false
//        self.textView.text = "speakrestname".localizedString()
    }
    
    
    // Searchbar Delegates
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !(searchBar.text?.isEmpty)! {
            let filteredUsers = allRrestaurant.filter({
                user in
                let dict = user
                let text = dict.restName.lowercased()
                let text1 = dict.categoryName.lowercased()
                return text.contains("\(searchBar.text?.lowercased() ?? "")") || text1.contains("\(searchBar.text?.lowercased() ?? "")")
            })
            if filteredUsers.isEmpty {
                //noMatchLabel.isHidden = false
                tblViewHome.isHidden = true
            } else {
                //noMatchLabel.isHidden = true
                tblViewHome.isHidden = false
            }
            restaurant = NSMutableArray(array: filteredUsers) as! [ModelClass]
            tblViewHome.reloadData()
        } else {
            tblViewHome.isHidden = false
            //noMatchLabel.isHidden = true
            restaurant = allRrestaurant
            tblViewHome.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
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


extension HomeVC : SpeakerDelegate {
    func textDidFinishSpeaking(_ speaker: Speaker, text: String) {
        speaker.delegate = nil
        listenRestName()
    }
    
    func sentToMenu(forRest rest : String,isFinal:Bool) {
        listenedText.append(" \(rest)")
        if isSearching {
            searchRestName(text: rest)
            return
        }
        
        if listenedText.lowercased().contains("search".localizedString().lowercased()) {
            isSearching = true
            searchRestName(text: rest)
            return
        }
        
        if isShowCart(text: listenedText) {
            let next = storyboard?.instantiateViewController(withIdentifier: "CartVC")
            navigationController?.pushViewController(next!, animated: true)
            self.listener.stopRecording()
            listenedText = ""
            return
        }
        let lastWord = rest.components(separatedBy: " ").last
        let filteredList = restaurant.filter({
            name in
            return name.restName.lowercased().contains(lastWord!.lowercased()) || name.categoryName.lowercased().contains(rest.lowercased())
        })
        
        if filteredList.isEmpty {
            if isFinal {
                speaker.speak(text: rest + " " + "restaurantnotfound".localizedString())
                listenedText = ""
            }
//            onClickSpeakNow(speakNowButton)
//            textView.text = "restaurantnotfound".localizedString()
        } else {
            if !isNextScreenShown {
//                let next = storyboard?.instantiateViewController(withIdentifier: "ItemVC")
//                navigationController?.pushViewController(next!, animated: true)
                let destVC : ItemVC = (storyboard?.instantiateViewController(withIdentifier: "ItemVC") as? ItemVC)!
                destVC.dataRestaurant = filteredList.first
                self.navigationController?.pushViewController(destVC, animated: true)
                isNextScreenShown = true
                self.listener.stopRecording()
                listenedText = ""
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
    
    func searchRestName(text:String){
        
        heightSearchBar.constant = 56
        
        let nameWithSpaces = text.lowercased().replacingOccurrences(of: listenedText.lowercased(), with: "")
        
        if nameWithSpaces.lowercased().contains("show".localizedString().lowercased()) || nameWithSpaces.lowercased().contains("cancel".localizedString().lowercased()) {
            restaurant = allRrestaurant
            tblViewHome.reloadData()
            isSearching = false
            listenedText = ""
            self.listener.stopRecording()
            self.onClickSpeakNow(self.speakNowButton)
            heightSearchBar.constant = 0
            return
        }
        let lastword = nameWithSpaces.components(separatedBy: " ").last
        if lastword == "search".localizedString().lowercased() {
            restaurant = allRrestaurant
            tblViewHome.reloadData()
            return
        }
        restaurant = allRrestaurant.filter({
            restaur in
            return restaur.restName.lowercased().contains(lastword!.lowercased())
        })
        tblViewHome.reloadData()
        //listenedText = "search".localizedString()
        print("searched \(nameWithSpaces)")
    }
    
}
