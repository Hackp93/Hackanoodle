//
//  Extensions.swift
//  SpeechTest
//
//  Created by jugal balara on 12/01/19.
//  Copyright © 2019 jugal balara. All rights reserved.
//

import Foundation
import UIKit

extension String {
    func localizedString()->String{
        
        let filePath    =   Bundle.main.path(forResource: "Localizable", ofType: "strings", inDirectory: "en.lproj")
        let dictionary = NSDictionary(contentsOfFile: filePath!)
        return "\(dictionary?.value(forKey: self) ?? self)"
    }
}

extension UIViewController {
    func showAlert(title:String,message : String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction((UIAlertAction(title: "OK", style: .cancel, handler: nil)))
        present(alert, animated: true, completion: nil)
    }
    
    
    func setUpNavigationBar(){
        
        self.navigationController?.navigationBar.barTintColor = UIColor.init(red: 220/255, green: 84/255, blue: 86/255, alpha: 1.0)
        self.navigationController?.navigationBar.tintColor  =   UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes    =   [NSAttributedString.Key.foregroundColor:UIColor.white,NSAttributedString.Key.font:UIFont(name: "HelveticaNeue-Bold", size: 18)!]
    }
}


extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {  // for swift 4.2 syntax just use ===> mode: UIView.ContentMode
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {  // for swift 4.2 syntax just use ===> mode: UIView.ContentMode
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}

let defaultListeningTime = 5
