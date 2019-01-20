//
//  CartTVCell.swift
//  SpeechTest
//
//  Created by mac on 12/01/19.
//  Copyright © 2019 jugal balara. All rights reserved.
//

import UIKit

class CartTVCell: UITableViewCell {

    @IBOutlet var dishName2: UILabel!
    @IBOutlet var dishName: UILabel!
    @IBOutlet var coupon: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCartItem(item:ItemModel){
        dishName.text = item.name
        dishName2.text = item.name
        
    }
    
    func setCoupon(couponName : String){
        if couponName.isEmpty {
            self.coupon.text = "Apply Coupon Code"
        } else {
            self.coupon.text = "Coupon Applied \(couponName)"
        }
    }

}
