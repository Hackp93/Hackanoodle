//
//  ModelClass.swift
//  SpeechTest
//
//  Created by mac on 12/01/19.
//  Copyright © 2019 jugal balara. All rights reserved.
//

import UIKit

class ModelClass: NSObject {

    var restId   =  ""
    var restName  = ""
    var categoryName  = ""
    var items : [ItemModel] = []
    var rating  = ""
    var restImage  = ""
    
    init(data : [String:Any]) {
        super.init()
        restId  =  "\(data["rest_id"] ?? "")"
        restName  =  "\(data["name"] ?? "")"
        categoryName  =  "\(data["category"] ?? "")"
        restImage  =  "\(data["img"] ?? "")"
        rating  =  "\(data["rating"] ?? "")"
        let itemData = data["dishes"] as? [[String : Any]] ?? [[:]]
        for menuItem in itemData {
            items.append(ItemModel(data: menuItem, student: self))
        }
    }
    
    
    class func getRestaurantList(restaurantDict : [[String:Any]])->[ModelClass]{
        
        var restaurantList = [ModelClass]()
        for restaurantD in restaurantDict {
            let member = ModelClass(data: restaurantD)
            restaurantList.append(member)
        }
        return restaurantList
    }
}


class ItemModel : NSObject {
    
    var name  =  ""
    var image  = ""
    var price   =   ""
    var category   =   ""

    init(data : [String:Any],student : ModelClass){
        
        name  =  "\(data["name"] ?? "")"
        image  =  "\(data["img"] ?? "")"
        price  =  "\(data["price"] ?? "")"
        category  =  "\(data["category"] ?? "")"
    }
}
