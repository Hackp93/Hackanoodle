//
//  ItemTVCell.swift
//  SpeechTest
//
//  Created by mac on 12/01/19.
//  Copyright © 2019 jugal balara. All rights reserved.
//

import UIKit

class ItemTVCell: UITableViewCell {

    @IBOutlet weak var imgItem: UIImageView!
    @IBOutlet weak var lblDishName: UILabel!
    @IBOutlet weak var lblcategoryName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setValues(dict: ItemModel) {
        
        if dict.image != "" {
            imgItem.downloaded(from: dict.image)
        }
        
        lblDishName.text = dict.name
        lblcategoryName.text = dict.category
        lblPrice.text = dict.price
    }
}
