//
//  Restaurant.swift
//  SpeechTest
//
//  Created by mac on 12/01/19.
//  Copyright © 2019 jugal balara. All rights reserved.
//

import UIKit

class Restaurant: NSObject {

    var restName: String
    var restImage: UIImage
    var restCategories:  String
    var strRating: String
    
    
    init(name: String, image: UIImage, category: String, rating: String ) {
        self.restName = name
        self.restImage = image
        self.restCategories = category
        self.strRating = rating
    }
}
