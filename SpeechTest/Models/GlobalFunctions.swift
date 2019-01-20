//
//  GlobalFunctions.swift
//  SpeechTest
//
//  Created by jugal balara on 13/01/19.
//  Copyright © 2019 jugal balara. All rights reserved.
//

import Foundation

func isShowCart(text : String)->Bool {
    if text.lowercased().contains("gotocart".localizedString()) || text.lowercased().contains("gotocart2".localizedString()) || text.lowercased().contains("gotocart3".localizedString()) {
        return true
    }
    if text.lowercased().contains("see".localizedString()) && text.lowercased().contains("cart".localizedString()) {
        return true
    }
    
    if (text.lowercased().contains("see".localizedString()) || text.lowercased().contains("view".localizedString()) || text.lowercased().contains("show".localizedString())) && text.lowercased().contains("cart".localizedString()) {
        return true
    }
    
    return false
}
